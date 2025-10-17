import 'package:flutter/material.dart';

/// Splash screen shown while the app initializes.
///
/// In later phases this widget can display a short animation or loading
/// indicator.  For now it acts as a placeholder to ensure the router
/// configuration compiles.
import 'package:go_router/go_router.dart';

/// Splash screen shown while the app initializes.
///
/// By default this widget displays a simple message and navigates
/// automatically to the main menu after a short delay.  As more
/// initialization logic is added (e.g. loading assets or checking
/// authentication), you can perform asynchronous work in `initState`.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay navigation to the home screen.  This simulates loading
    // work that might occur during app start‑up.  Replace this
    // with actual initialization logic as needed.
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.go('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Splash Screen'),
      ),
    );
  }
}