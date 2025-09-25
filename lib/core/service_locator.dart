import 'package:get_it/get_it.dart';

import '../services/audio_engine_service.dart';
import '../services/gamification_bloc.dart';
import '../core/navigation/app_router.dart';
import 'package:go_router/go_router.dart';

/// Configure and register all lazy singletons and factories for the app.
///
/// This method should be invoked before the application starts so that
/// dependencies are available via [GetIt.instance].  All registrations
/// include explicit type parameters to avoid runtime type mismatches.
void setupServiceLocator() {
  final getIt = GetIt.instance;
  // Register the audio engine.  Use lazy registration to avoid
  // constructing the service until it is first requested.
  if (!getIt.isRegistered<AudioEngineService>()) {
    getIt.registerLazySingleton<AudioEngineService>(() => AudioEngineService());
  }
  // Register the gamification BLoC.  A fresh instance is created lazily
  // when first accessed.
  if (!getIt.isRegistered<GamificationBloc>()) {
    getIt.registerLazySingleton<GamificationBloc>(() => GamificationBloc());
  }
  // Register the app router so that any component in the game can perform
  // navigation without direct access to the BuildContext.  GoRouter is
  // registered as a singleton pointing at the static router exposed on
  // [AppRouter].
  if (!getIt.isRegistered<GoRouter>()) {
    getIt.registerLazySingleton<GoRouter>(() => AppRouter.router);
  }
}