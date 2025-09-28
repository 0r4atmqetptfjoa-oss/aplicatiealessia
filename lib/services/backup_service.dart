
import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'profile_service.dart';

final getIt = GetIt.instance;

class ParentalControlService {
  bool disableParticles = false;
  bool bgMusicEnabled = true;
  int dailyMinutes = 30;
  String parentPin = '0000';
  Future<void> save() async {}
}

class BackupService {
  Future<String> exportJson() async {
    final prof = getIt<ProfileService>();
    final data = {
      'profiles': prof.profiles.value.map((e) => e.toJson()).toList(),
      'activeProfile': prof.activeId.value,
      'parental': {
        'disableParticles': getIt<ParentalControlService>().disableParticles,
        'bgMusicEnabled': getIt<ParentalControlService>().bgMusicEnabled,
        'dailyMinutes': getIt<ParentalControlService>().dailyMinutes,
        'parentPin': getIt<ParentalControlService>().parentPin,
      },
      'graph': json.decode(getIt<StoryService>().graphJson),
    };
    return json.encode(data);
  }

  Future<void> importJson(String jsonStr) async {
    final data = json.decode(jsonStr) as Map<String, dynamic>;
    final prof = getIt<ProfileService>();

    final list = (data['profiles'] as List).cast<Map<String, dynamic>>();
    prof.profiles.value = list.map(ChildProfile.fromJson).toList();

    prof.activeId.value = data['activeProfile'] as String?;
    if (prof.activeId.value != null) {
      await prof.setActive(prof.activeId.value!);
    }

    final p = getIt<ParentalControlService>();
    final parental = (data['parental'] as Map<String, dynamic>?) ?? const {};
    p
      ..disableParticles = (parental['disableParticles'] as bool?) ?? p.disableParticles
      ..bgMusicEnabled = (parental['bgMusicEnabled'] as bool?) ?? p.bgMusicEnabled
      ..dailyMinutes = (parental['dailyMinutes'] as int?) ?? p.dailyMinutes
      ..parentPin = (parental['parentPin'] as String?) ?? p.parentPin;
    await p.save();
  }
}
