import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';
import 'package:video_player/video_player.dart';

import 'l10n/app_localizations.dart';
import 'src/core/router/app_router.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _precacheAssets();
    });
  }

  Future<void> _precacheAssets() async {
    // Pre-cache videos
    final videoController = VideoPlayerController.asset('assets/video/menu/main_background_loop.mp4');
    await videoController.initialize();
    videoController.dispose();

    // Pre-cache Rive animations
    await RiveFile.asset('assets/rive/menu_buttons.riv');
    await RiveFile.asset('assets/rive/title.riv');

    // Pre-cache initial images
    if (mounted) await precacheImage(const AssetImage('assets/images/sounds_module/categories/ferma.png'), context);
    if (mounted) await precacheImage(const AssetImage('assets/images/sounds_module/categories/pasari.png'), context);
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
