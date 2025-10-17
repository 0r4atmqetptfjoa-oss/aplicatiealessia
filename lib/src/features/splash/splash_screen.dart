import 'package:flutter/material.dart';

/// Splash screen shown while the app initializes.
///
/// In later phases this widget can display a short animation or loading
/// indicator.  For now it acts as a placeholder to ensure the router
/// configuration compiles.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Splash Screen'),
      ),
    );
  }
}