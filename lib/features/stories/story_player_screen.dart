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
            // TODO (Răzvan): Înlocuiește cu o ilustrație finală pentru ecranul de povești
            Image.asset('assets/images/placeholders/placeholder_square.png', width: 200).animate().fade().scale(),
            const SizedBox(height: 16),
            const Text('Playerul de povești va fi disponibil în Faza 2.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
