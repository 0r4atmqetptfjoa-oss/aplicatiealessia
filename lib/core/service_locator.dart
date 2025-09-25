import 'package:get_it/get_it.dart';

import '../services/audio_engine_service.dart';
import '../services/gamification_bloc.dart';
import '../core/navigation/app_router.dart';
import 'package:go_router/go_router.dart';

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
  // Register the GoRouter instance so that Flame components can access
  // navigation callbacks via the service locator.  Without this registration
  // the locator<GoRouter>() call in HomeGame would throw.
  if (!getIt.isRegistered<GoRouter>()) {
    getIt.registerLazySingleton<GoRouter>(() => AppRouter.router);
  }
}