import 'dart:convert';
import 'dart:io';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/analytics_service.dart';
import 'package:alesia/services/parental_control_service.dart';
import 'package:alesia/services/profile_service.dart';
import 'package:alesia/services/progress_service.dart';
import 'package:alesia/services/quests_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

class BackupService {
  Future<Map<String, dynamic>> buildSnapshot() async {
    final ps = getIt<ProgressService>();
    final pcs = getIt<ParentalControlService>();
    final prof = getIt<ProfileService>();
    final qs = getIt<QuestsService>();
    final an = getIt<AnalyticsService>();
    return {
      'v': 1,
      'progress': ps.stickers,
      'bestStreak': {
        'piano': ps.getBestStreak('piano'),
        'drums': ps.getBestStreak('drums'),
        'xylophone': ps.getBestStreak('xylophone'),
        'organ': ps.getBestStreak('organ'),
      },
      'parental': {
        'disableParticles': pcs.disableParticles,
        'bgMusicEnabled': pcs.bgMusicEnabled,
        'dailyMinutes': pcs.dailyMinutes,
        'pinHash': pcs.pinHash,
      },
      'profiles': prof.profiles.value.map((p) => p.toJson()).toList(),
      'activeProfile': prof.activeId.value,
      'quests': qs.allProgress,
      'analytics': an.events.map((e) => e.toJson()).toList(),
    };
  }

  Future<File> exportToFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/AlesiaBackup_${DateTime.now().millisecondsSinceEpoch}.alesia';
    final data = json.encode(await buildSnapshot());
    final f = File(path);
    await f.writeAsString(data);
    return f;
  }

  Future<void> restoreFromFile() async {
    final res = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['alesia']);
    if (res == null || res.files.isEmpty) return;
    final file = File(res.files.single.path!);
    final jsonStr = await file.readAsString();
    final snap = json.decode(jsonStr) as Map<String, dynamic>;
    await _restore(snap);
  }

  Future<void> _restore(Map<String, dynamic> s) async {
    final ps = getIt<ProgressService>();
    final pcs = getIt<ParentalControlService>();
    if (s['progress'] is Map) {
      final prog = Map<String, dynamic>.from(s['progress']);
      for (final e in prog.entries) {
        final count = (e.value as num).toInt();
        for (int i=0;i<count;i++) { await ps.awardSticker(e.key); }
      }
    }
    if (s['parental'] is Map) {
      final p = Map<String, dynamic>.from(s['parental']);
      pcs.disableParticles = p['disableParticles'] ?? pcs.disableParticles;
      pcs.bgMusicEnabled = p['bgMusicEnabled'] ?? pcs.bgMusicEnabled;
      pcs.dailyMinutes = p['dailyMinutes'] ?? pcs.dailyMinutes;
      pcs.pinHash = p['pinHash'];
      await pcs.save();
    }
  }
}
