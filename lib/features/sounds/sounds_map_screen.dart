import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SoundsMapScreen extends StatelessWidget {
  const SoundsMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sounds = ['vaca', 'leu', 'masina', 'pisica', 'maimuta', 'ambulanta'];

    return Scaffold(
      appBar: AppBar(title: const Text('Harta Sunetelor')),
      body: GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: sounds.length,
        itemBuilder: (context, i) {
          return Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // TODO (Răzvan): Înlocuiește cu iconița finală '${sounds[i]}.png'
                    Expanded(child: Image.asset('assets/images/placeholders/placeholder_square.png')),
                    const SizedBox(height: 8),
                    Text(sounds[i].toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(duration: 400.ms, delay: (i * 80).ms).scale(begin: const Offset(0.95, 0.95));
        },
      ),
    );
  }
}