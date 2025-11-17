import 'package:flutter/material.dart';

/// A screen for playing a particular sound.
///
/// In a real application this would load an audio asset and play it when the
/// user presses a button. Here we display a placeholder message.
class SoundsDetailScreen extends StatelessWidget {
  const SoundsDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sound Detail')),
      body: const Center(
        child: Text('Sound detail screen will be implemented here.'),
      ),
    );
  }
}