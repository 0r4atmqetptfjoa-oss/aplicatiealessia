import 'package:alesia/services/audio_service.dart';
import 'package:alesia/services/progress_service.dart';
import 'package:get_it/get_it.dart';
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
  getIt.registerLazySingleton<AudioService>(() => AudioService());
  getIt.registerLazySingleton<ProgressService>(() => ProgressService());
  getIt.registerLazySingleton<ProfileService>(() => ProfileService());
  getIt.registerLazySingleton<ParentalControlService>(() => ParentalControlService());
  getIt.registerLazySingleton<AnalyticsService>(() => AnalyticsService());
  getIt.registerLazySingleton<QuestService>(() => QuestService());
  getIt.registerLazySingleton<ThemeService>(() => ThemeService());
  getIt.registerLazySingleton<ABTestService>(() => ABTestService());
  getIt.registerLazySingleton<StoryService>(() => StoryService());
  getIt.registerLazySingleton<StoryLayoutService>(() => StoryLayoutService());
  getIt.registerLazySingleton<StoryHistoryService>(() => StoryHistoryService());
}
