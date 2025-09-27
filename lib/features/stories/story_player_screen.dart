import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StoryPlayerScreen extends StatelessWidget {
  const StoryPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Povești')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // TODO (Răzvan): Înlocuiește cu un preview pentru 'carte de povești'
            Image.asset('assets/images/placeholders/placeholder_square.png', height: 220),
            const SizedBox(height: 24),
            const Text('Player de povești – În curând', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const Text('Această secțiune va reda povești ilustrate cu narator și muzică.'),
          ],
        ).animate().fadeIn(duration: 500.ms).moveY(begin: 20, end: 0, duration: 500.ms),
      ),
    );
  }
}