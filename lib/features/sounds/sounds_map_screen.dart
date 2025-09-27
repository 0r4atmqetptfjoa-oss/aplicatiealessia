import 'package:alesia/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it/get_it.dart';

class SoundsMapScreen extends StatelessWidget {
  const SoundsMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = GetIt.I<AudioService>();
    final items = [
      'Vacă', 'Leu', 'Mașină', 'Pisică', 'Maimuță', 'Ambulanță'
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Harta Sunetelor')),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () { audio.playUiClick(); },
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      aspectRatio: 1,
                      // TODO (Răzvan): Înlocuiește cu iconița finală corespunzătoare.
                      child: Image.asset('assets/images/placeholders/placeholder_square.png', fit: BoxFit.cover),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(items[index], style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ).animate().fadeIn().scale(delay: (index * 80).ms);
        },
      ),
    );
  }
}
