import 'package:alesia/services/audio_service.dart';
import 'package:alesia/services/progress_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  getIt.registerLazySingleton<AudioService>(() => AudioService());
  getIt.registerLazySingleton<ProgressService>(() => ProgressService());
  getIt.registerLazySingleton<ProfileService>(() => ProfileService());
  getIt.registerLazySingleton<ParentalService>(() => ParentalService());
  getIt.registerLazySingleton<AnalyticsService>(() => AnalyticsService());
  getIt.registerLazySingleton<QuestService>(() => QuestService());
  getIt.registerLazySingleton<ThemeService>(() => ThemeService());
}
