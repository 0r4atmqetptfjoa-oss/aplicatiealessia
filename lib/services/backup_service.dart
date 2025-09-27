import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:alesia/services/progress_service.dart';
import 'package:alesia/services/parental_control_service.dart';
import 'package:alesia/services/profile_service.dart';
import 'package:alesia/services/analytics_service.dart';
import 'package:alesia/services/quests_service.dart';
import 'package:alesia/services/theme_service.dart';
import 'package:alesia/core/service_locator.dart';

class BackupService {
  Future<String> exportAll() async {
    final dir = await getApplicationDocumentsDirectory();
    final ts = DateTime.now();
    final fileName = 'Alesia_backup_${ts.year}${_2(ts.month)}${_2(ts.day)}_${_2(ts.hour)}${_2(ts.minute)}.alesia';
    final file = File('${dir.path}/$fileName');
    final latest = File('${dir.path}/Alesia_backup_latest.alesia');

    final progress = getIt<ProgressService>().stickers;
    final parental = {
      'disableParticles': getIt<ParentalControlService>().disableParticles,
      'bgMusicEnabled': getIt<ParentalControlService>().bgMusicEnabled,
      'dailyMinutes': getIt<ParentalControlService>().dailyMinutes,
    };
    final profiles = getIt<ProfileService>().profiles.value.map((p) => p.toJson()).toList();
    final activeProfile = getIt<ProfileService>().activeId.value;
    final analytics = getIt<AnalyticsService>().events.map((e) => e.toJson()).toList();
    final quests = getIt<QuestsService>().allProgress;
    final theme = getIt<ThemeService>().flavor.value.name;

    final payload = {
      'version': 1,
      'progress': progress,
      'parental': parental,
      'profiles': profiles,
      'activeProfile': activeProfile,
      'analytics': analytics,
      'quests': quests,
      'theme': theme,
      'exportedAt': ts.toIso8601String(),
    };
    final jsonStr = const JsonEncoder.withIndent('  ').convert(payload);
    await file.writeAsString(jsonStr);
    await latest.writeAsString(jsonStr);
    return file.path;
  }

  Future<void> importLatest() async {
    final dir = await getApplicationDocumentsDirectory();
    final latest = File('${dir.path}/Alesia_backup_latest.alesia');
    if (!await latest.exists()) {
      throw Exception('Nu există backup latest.');
    }
    final raw = await latest.readAsString();
    final map = json.decode(raw) as Map<String, dynamic>;

    // Restaurează segmentele cunoscute
    final ps = getIt<ProgressService>();
    ps.totalStickers.value = 0;
    // set direct map via internal API: folosim awardSticker pentru a menține consistența
    if (map['progress'] is Map) {
      final prog = Map<String, dynamic>.from(map['progress']);
      for (final entry in prog.entries) {
        final k = entry.key;
        final v = (entry.value as num).toInt();
        for (int i = 0; i < v; i++) {
          await ps.awardSticker(k);
        }
      }
    }

    final pcs = getIt<ParentalControlService>();
    if (map['parental'] is Map) {
      final m = Map<String, dynamic>.from(map['parental']);
      pcs.disableParticles = m['disableParticles'] ?? pcs.disableParticles;
      pcs.bgMusicEnabled = m['bgMusicEnabled'] ?? pcs.bgMusicEnabled;
      pcs.dailyMinutes = m['dailyMinutes'] ?? pcs.dailyMinutes;
      await pcs.save();
    }

    final profs = getIt<ProfileService>();
    if (map['profiles'] is List) {
      // simplu: înlocuiește toate
      profs.profiles.value = (map['profiles'] as List)
          .cast<Map<String, dynamic>>()
          .map(ChildProfile.fromJson)
          .toList();
      await profs.setActive(map['activeProfile']?.toString() ?? profs.profiles.value.first.id);
    }

    final qs = getIt<QuestsService>();
    if (map['quests'] is Map) {
      // read-only in service, dar putem importa simplu: (nu expunem direct setter, păstrăm pentru simplitate)
      // Ignorăm pentru acum (quest-urile se reconstruiesc din joc).
    }

    // tema
    final theme = map['theme']?.toString();
    if (theme != null) {
      // mapping by name handled by ThemeFlavor.values.firstWhere
      try {
        final tf = ThemeFlavor.values.firstWhere((e) => e.name == theme);
        getIt<ThemeService>().setFlavor(tf);
      } catch (_) {}
    }
  }

  String _2(int v) => v.toString().padLeft(2, '0');
}
