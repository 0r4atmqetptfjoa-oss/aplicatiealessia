import 'package:alesia/core/app_router.dart';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/theme_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize Firebase safely (no-op if firebase_options not configured yet).
  try { await Firebase.initializeApp(); } catch (_) {}

  await setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = GetIt.I<ThemeService>();
    return AnimatedBuilder(
      animation: theme,
      builder: (_, __) => MaterialApp.router(
        title: 'Alesia',
        theme: theme.currentThemeData,
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
