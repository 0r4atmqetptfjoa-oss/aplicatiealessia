import 'package:alesia/services/audio_service.dart';
import 'package:alesia/services/progress_service.dart';
import 'package:alesia/services/time_tracker_service.dart';
import 'package:alesia/services/theme_service.dart';
import 'package:alesia/services/profiles_service.dart';
import 'package:alesia/services/analytics_service.dart';
import 'package:alesia/services/quests_service.dart';
import 'package:alesia/services/parents_service.dart';
import 'package:alesia/services/profile_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerLazySingleton<AudioService>(() => AudioService());
  getIt.registerLazySingleton<ProgressService>(() => ProgressService());
  getIt.registerLazySingleton<ThemeService>(() => ThemeService());
  getIt.registerLazySingleton<ProfilesService>(() => ProfilesService());
  getIt.registerLazySingleton<AnalyticsService>(() => AnalyticsService());
  getIt.registerLazySingleton<QuestsService>(() => QuestsService());
  getIt.registerLazySingleton<TimeTrackerService>(() => TimeTrackerService());
  getIt.registerLazySingleton<ParentsService>(() => ParentsService());
  getIt.registerLazySingleton<ProfileService>(() => ProfileService());
  // Pre-init audio (safe: it catches and logs failures if placeholder isn't playable)
  await getIt<AudioService>().init();
}