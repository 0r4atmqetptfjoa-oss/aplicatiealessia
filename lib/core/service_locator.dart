import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:alesia/services/audio_service.dart';
import 'package:alesia/services/progress_service.dart';
import 'package:alesia/services/profile_service.dart';
import 'package:alesia/services/parental_control_service.dart';
import 'package:alesia/services/analytics_service.dart';
import 'package:alesia/services/quest_service.dart';
import 'package:alesia/services/theme_service.dart';
import 'package:alesia/services/ab_test_service.dart';
import 'package:alesia/services/story_service.dart';
import 'package:alesia/services/story_layout_service.dart';
import 'package:alesia/services/story_history_service.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  final prefs = await SharedPreferences.getInstance();

  getIt.registerLazySingleton<AudioService>(() => AudioService());
  getIt.registerLazySingleton<ProgressService>(() => ProgressService());
  getIt.registerLazySingleton<ProfileService>(() => ProfileService());
  getIt.registerLazySingleton<ParentalControlService>(() => ParentalControlService());
  getIt.registerLazySingleton<AnalyticsService>(() => AnalyticsService());
  getIt.registerLazySingleton<QuestService>(() => QuestService());
  getIt.registerLazySingleton<ThemeService>(() => ThemeService(prefs));
  getIt.registerLazySingleton<ABTestService>(() => ABTestService(prefs));
  getIt.registerLazySingleton<StoryService>(() => StoryService());
  getIt.registerLazySingleton<StoryLayoutService>(() => StoryLayoutService());
  getIt.registerLazySingleton<StoryHistoryService>(() => StoryHistoryService());

  // Warm up services that need initialization.
  await getIt<ThemeService>().init();
  await getIt<ABTestService>().init();
  await getIt<AudioService>().init();
}
