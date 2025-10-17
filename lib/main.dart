// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// L10n (generated via flutter gen-l10n)
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Firebase (optional - guarded)
import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart'; // TODO(restore): uncomment after running `flutterfire configure`

import 'src/features/main_menu/main_menu_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to landscape
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Try to init Firebase, but don't fail if firebase_options.dart is missing.
  try {
    await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform, // TODO(restore)
    );
  } catch (e) {
    // Safe fallback so the app can run without Firebase during local dev
    debugPrint('Firebase init skipped: $e');
  }

  runApp(const LumeaAlessieiApp());
}

class LumeaAlessieiApp extends StatelessWidget {
  const LumeaAlessieiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lumea Alessiei',
      // L10n wiring
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MainMenuScreen(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
      ),
    );
  }
}
