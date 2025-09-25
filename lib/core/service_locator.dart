import 'package:get_it/get_it.dart';

import '../services/audio_engine_service.dart';
import '../services/gamification_bloc.dart';

/// Configure and register all lazy singletons and factories for the app.
///
/// This method should be invoked before the application starts so that
/// dependencies are available via [GetIt.instance].
void setupServiceLocator() {
  final getIt = GetIt.instance;
  if (!getIt.isRegistered<AudioEngineService>()) {
    getIt.registerLazySingleton<AudioEngineService>(() => AudioEngineService());
  }
  if (!getIt.isRegistered<GamificationBloc>()) {
    getIt.registerLazySingleton<GamificationBloc>(() => GamificationBloc());
  }
}