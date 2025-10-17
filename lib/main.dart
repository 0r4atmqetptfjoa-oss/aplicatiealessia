import 'package:flutter/material.dart';
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