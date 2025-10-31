import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n/app_localizations.dart';
import 'src/core/router/app_router.dart';
import 'src/services/precache_service.dart';

/// The main entry point of the application.
Future<void> main() async {
  // Ensure that the Flutter binding is initialized before any other code is executed.
  WidgetsFlutterBinding.ensureInitialized();

  // Lock the screen orientation to landscape mode.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Run the app within a ProviderScope to enable Riverpod for state management.
  runApp(const ProviderScope(child: LumeaAlessieiApp()));
}

/// The root widget of the application.
class LumeaAlessieiApp extends ConsumerStatefulWidget {
  const LumeaAlessieiApp({super.key});

  @override
  ConsumerState<LumeaAlessieiApp> createState() => _LumeaAlessieiAppState();
}

class _LumeaAlessieiAppState extends ConsumerState<LumeaAlessieiApp> {
  @override
  void initState() {
    super.initState();
    // After the first frame is rendered, start pre-caching critical assets.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(precacheServiceProvider).precacheCriticalAssets(context, ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the app router provider to get the router configuration.
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      // Disable the debug banner in the top-right corner.
      debugShowCheckedModeBanner: false,
      // Set the title of the application.
      title: 'Lumea Alessiei',
      // Configure localization delegates for internationalization.
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // Set the router configuration for the app.
      routerConfig: router,
      // Define the theme of the application.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
      ),
    );
  }
}
