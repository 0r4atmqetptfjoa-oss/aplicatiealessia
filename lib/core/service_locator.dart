import 'package:alesia/services/audio_service.dart';
import 'package:alesia/services/quest_service.dart';
import 'package:alesia/services/analytics_service.dart';
import 'package:alesia/services/parental_service.dart';
import 'package:alesia/services/profile_service.dart';
import 'package:alesia/services/theme_service.dart';
import 'package:alesia/services/progress_service.dart';
import 'package:alesia/services/quests_service.dart';
import 'package:alesia/services/parental_control_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerLazySingleton<AudioService>(() => AudioService());
  getIt.registerLazySingleton<ProgressService>(() => ProgressService());
  getIt.registerLazySingleton<ThemeService>(() => ThemeService());
  getIt.registerLazySingleton<ProfileService>(() => ProfileService());
  getIt.registerLazySingleton<ParentalService>(() => ParentalService());
  getIt.registerLazySingleton<AnalyticsService>(() => AnalyticsService());
  getIt.registerLazySingleton<QuestService>(() => QuestService());
  // Initialize services that require async setup
  await getIt<AudioService>().init();
}
