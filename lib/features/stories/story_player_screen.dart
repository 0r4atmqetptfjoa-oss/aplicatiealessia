import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
class StoryPlayerScreen extends StatelessWidget {
  const StoryPlayerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Povești')),
      body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        // TODO (Răzvan): Înlocuiește cu UI final pentru player
        Image.asset('assets/images/placeholders/placeholder_square.png', width: 180),
        const SizedBox(height: 12),
        const Text('Player Povești (în lucru)'),
      ]).animate().fade(duration: 300.ms).scale(),),
    );
  }
}
