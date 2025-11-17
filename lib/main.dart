import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/subscription_service.dart';
import 'services/settings_service.dart';
import 'app_router.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const NumvpApp());
}

/// The root widget of the NumVP application.
///
/// This widget sets up the [MaterialApp.router] and provides localization
/// delegates and supported locales. It also wraps the application with
/// [MultiProvider] so that additional services can be injected later.
class NumvpApp extends StatelessWidget {
  const NumvpApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter().router;
    return MultiProvider(
      providers: [
        // Provide the subscription service so we can gate content based on
        // premium status.
        ChangeNotifierProvider(create: (_) => SubscriptionService()),
        // Provide the settings service so the settings screen can modify
        // preferences like sound and music.
        ChangeNotifierProvider(create: (_) => SettingsService()),
      ],
      child: MaterialApp.router(
        title: 'NumVP',
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('ro'),
        ],
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}