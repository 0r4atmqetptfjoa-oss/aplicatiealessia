// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// L10n (local, fara flutter_gen)
import 'l10n/app_localizations.dart';

import 'src/features/main_menu/main_menu_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to landscape
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const LumeaAlessieiApp());
}

class LumeaAlessieiApp extends StatelessWidget {
  const LumeaAlessieiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lumea Alessiei',
      // L10n wiring (local)
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        // Material/Widgets/Cupertino delegates pot fi adaugate daca ai nevoie de traduceri sistem.
        // Dar pentru aceasta implementare minimalista nu sunt obligatorii.
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
