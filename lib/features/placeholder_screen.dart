import 'package:flutter/material.dart';

/// A simple placeholder view used for routes that are not yet implemented.
///
/// Displays a title in the app bar and a centred message letting the user
/// know that the screen is a placeholder.  This allows navigation to be
/// wired up during phase 1 without blocking on final feature content.
class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          '$title – conținutul va fi adăugat în fazele următoare.',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}