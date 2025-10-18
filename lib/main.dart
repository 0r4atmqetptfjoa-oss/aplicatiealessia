import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n/app_localizations.dart';
import 'src/core/router/app_router.dart';
import 'src/services/precache_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to landscape
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const ProviderScope(child: LumeaAlessieiApp()));
}

class LumeaAlessieiApp extends ConsumerStatefulWidget {
  const LumeaAlessieiApp({super.key});

  @override
  ConsumerState<LumeaAlessieiApp> createState() => _LumeaAlessieiAppState();
}

class _LumeaAlessieiAppState extends ConsumerState<LumeaAlessieiApp> {
  @override
  void initState() {
    super.initState();
    // After the first frame, kick off the asset pre-caching.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(precacheServiceProvider).precacheCriticalAssets(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Lumea Alessiei',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
      ),
    );
  }
}
