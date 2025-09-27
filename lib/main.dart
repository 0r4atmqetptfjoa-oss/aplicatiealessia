import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'core/di/service_locator.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/instruments/presentation/piano_screen.dart';
import 'features/instruments/presentation/drums_screen.dart';
import 'features/instruments/presentation/xylophone_screen.dart';
import 'features/instruments/presentation/organ_screen.dart';
import 'features/instruments/presentation/instruments_menu_screen.dart';

/// Entry point for the Alesia application.
///
/// This file configures global settings such as device orientation,
/// initializes the dependency injection container and wires up the
/// application router. The root widget uses [MaterialApp.router] to
/// integrate with `go_router` for declarative navigation.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Ensure the app runs only in portrait mode.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  // Configure dependency injection before the app starts.
  await setupLocator();
  runApp(const MyApp());
}

/// Defines the top‑level routes for the application.
final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'instrumente',
              // Show the instruments menu when navigating to /instrumente.
              builder: (context, state) => const InstrumentsMenuScreen(),
          routes: [
            GoRoute(
              path: 'pian',
              builder: (context, state) => const PianoScreen(),
            ),
            GoRoute(
              path: 'tobe',
              builder: (context, state) => const DrumsScreen(),
            ),
            GoRoute(
              path: 'xilofon',
              builder: (context, state) => const XylophoneScreen(),
            ),
            GoRoute(
              path: 'orga',
              builder: (context, state) => const OrganScreen(),
            ),
          ],
        ),
        GoRoute(
          path: 'canciones',
          builder: (context, state) => const PlaceholderScreen(title: 'Cântece'),
        ),
        GoRoute(
          path: 'povesti',
          builder: (context, state) => const PlaceholderScreen(title: 'Povești'),
        ),
        GoRoute(
          path: 'jocuri',
          builder: (context, state) => const PlaceholderScreen(title: 'Jocuri'),
        ),
        GoRoute(
          path: 'sunete',
          builder: (context, state) => const PlaceholderScreen(title: 'Sunete'),
        ),
      ],
    ),
  ],
);

/// Root widget for the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Alesia',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Simple placeholder page used for routes that haven't been implemented yet.
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title - În curând!',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}