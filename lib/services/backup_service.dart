import 'dart:convert';
import 'dart:io';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/analytics_service.dart';
import 'package:alesia/services/parental_control_service.dart';
import 'package:alesia/services/profile_service.dart';
import 'package:alesia/services/progress_service.dart';
import 'package:alesia/services/quests_service.dart';
import 'package:path_provider/path_provider.dart';

class BackupService {
  Future<String> exportToFile() async {
    final data = await _collect();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/alesia_backup_${DateTime.now().millisecondsSinceEpoch}.alesia');
    await file.writeAsString(json.encode(data));
    return file.path;
  }

  Future<void> importFromFile(File file) async {
    final raw = await file.readAsString();
    final data = json.decode(raw) as Map<String, dynamic>;
    await _apply(data);
  }

  Future<Map<String, dynamic>> _collect() async {
    final p = getIt<ParentalControlService>();
    final prof = getIt<ProfileService>();
    final prog = getIt<ProgressService>();
    final a = getIt<AnalyticsService>();
    final q = getIt<QuestsService>();
    return {
      'parental': {'disableParticles': p.disableParticles, 'bgMusicEnabled': p.bgMusicEnabled, 'dailyMinutes': p.dailyMinutes, 'parentPin': p.parentPin},
      'profiles': prof.profiles.value.map((e) => e.toJson()).toList(),
      'activeProfile': prof.activeId.value,
      'stickers': prog.stickers,
      'analytics': a.events.map((e) => e.toJson()).toList(),
      'quests': q.allProgress,
    };
  }

  Future<void> _apply(Map<String, dynamic> data) async {
    final p = getIt<ParentalControlService>()
      ..disableParticles = data['parental']['disableParticles'] ?? p.disableParticles
      ..bgMusicEnabled = data['parental']['bgMusicEnabled'] ?? p.bgMusicEnabled
      ..dailyMinutes = data['parental']['dailyMinutes'] ?? p.dailyMinutes
      ..parentPin = data['parental']['parentPin'] ?? p.parentPin;
    await p.save();

    final prof = getIt<ProfileService>();
    final list = (data['profiles'] as List).cast<Map<String, dynamic>>();
    prof.profiles.value = list.map(ChildProfile.fromJson).toList();
    prof.activeId.value = data['activeProfile'] as String?;
    if (prof.activeId.value != null) {
      await prof.setActive(prof.activeId.value!);
    }

    final prog = getIt<ProgressService>();
    for (final e in (data['stickers'] as Map<String, dynamic>).entries) {
      for (int i = 0; i < (e.value as int); i++) {
        await prog.awardSticker(e.key);
      }
    }

    // analytics
    final a = getIt<AnalyticsService>();
    for (final ev in (data['analytics'] as List).cast<Map<String, dynamic>>()) {
      await a.log(ev['type'], Map<String, dynamic>.from(ev['data']));
    }
  }
}
