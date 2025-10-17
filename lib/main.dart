import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/core/router/app_router.dart';

/// Entry point for the Lumea Alessiei application.
///
/// This wraps the entire widget tree in a [ProviderScope] to enable
/// Riverpod throughout the app.  The [MaterialApp.router] widget is
/// configured with the router defined in [appRouterProvider].  Using
/// GoRouter makes navigation declarative and enables deep-linking support.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Force the application into landscape mode on Android.  This app is
  // designed for landscape use only.  If you need to support
  // additional orientations on other platforms in the future, adjust
  // this call accordingly.
  SystemChrome.setPreferredOrientations([
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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Lumea Alessiei',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      routerConfig: router,
    );
  }
}