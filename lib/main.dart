import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/navigation/app_router.dart';
import 'core/service_locator.dart';
import 'services/audio_engine_service.dart';
import 'package:get_it/get_it.dart';

/// Entry point of the Alesia application.
///
/// This function ensures that Flutter bindings are initialised and locks the
/// device orientation to portrait before bootstrapping the app.  The app
/// delegates its navigation to a central [GoRouter] configured in
/// [AppRouter].
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Set up dependency injection before anything else.  This registers
  // singletons for the audio engine and gamification BLoC.
  setupServiceLocator();
  // Initialise the audio engine so it is ready to play sounds.  Errors
  // during initialisation are ignored for now; sounds will simply not
  // play if the engine isn't available.
  await GetIt.instance.get<AudioEngineService>().init();
  // Restrict the application to portrait orientation only.  This prevents
  // accidental rotation on phones and is required by the spec for phase 1.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

/// Root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Alesia',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}