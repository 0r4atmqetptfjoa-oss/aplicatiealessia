import 'package:alesia/core/app_router.dart';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/audio_service.dart';
import 'package:alesia/services/progress_service.dart';
import 'package:alesia/services/seasonal_theme_service.dart';
import 'package:alesia/services/profile_service.dart';
import 'package:alesia/services/parental_service.dart';
import 'package:alesia/services/analytics_service.dart';
import 'package:alesia/services/quests_service.dart';
import 'package:alesia/services/synth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await setupLocator();
  // Inițializează motorul audio (SoLoud).
  await getIt<AudioService>().init();
  await getIt<SynthService>().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Alesia',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
