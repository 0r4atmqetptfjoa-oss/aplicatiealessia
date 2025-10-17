import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:rive/rive.dart';
import 'src/core/router/app_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> precacheAssets(BuildContext context) async {
  await precacheImage(const AssetImage('assets/images/sounds_module/pasari_background.png'), context);
  await precacheImage(const AssetImage('assets/images/sounds_module/ferma_background.png'), context);
  await precacheImage(const AssetImage('assets/images/sounds_module/marine_background.png'), context);
  await precacheImage(const AssetImage('assets/images/sounds_module/vehicule_background.png'), context);
  await precacheImage(const AssetImage('assets/images/sounds_module/salbatice_background.png'), context);

  // Pre-cache Rive animations
  await RiveFile.asset('assets/rive/menu_buttons.riv');
  await RiveFile.asset('assets/rive/title.riv');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Force the application into landscape mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const ProviderScope(child: LumeaAlessieiApp()));
}

class LumeaAlessieiApp extends ConsumerWidget {
  const LumeaAlessieiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    // Pre-cache assets after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheAssets(context);
    });

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Lumea Alessiei',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
