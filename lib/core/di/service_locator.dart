import 'package:get_it/get_it.dart';

/// A global instance of the [GetIt] service locator.
final GetIt getIt = GetIt.instance;

/// Registers application wide services into the service locator.
///
/// At this early stage of the project there are no concrete services to
/// register, but this method exists so new services (e.g. audio players,
/// data repositories, analytics) can be wired up in one place.
Future<void> setupLocator() async {
  // Example registration:
  // getIt.registerLazySingleton<SomeService>(() => SomeServiceImpl());
}