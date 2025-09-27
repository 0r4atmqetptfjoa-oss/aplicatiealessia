import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SoundsMapScreen extends StatelessWidget {
  const SoundsMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'label': 'Vacă', 'asset': 'vaca.png'},
      {'label': 'Leu', 'asset': 'leu.png'},
      {'label': 'Mașină', 'asset': 'masina.png'},
      {'label': 'Pisică', 'asset': 'pisica.png'},
      {'label': 'Maimuță', 'asset': 'maimuta.png'},
      {'label': 'Ambulanță', 'asset': 'ambulanta.png'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Harta Sunetelor')),
      body: GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: items.length,
        itemBuilder: (context, idx) {
          final it = items[idx];
          return GestureDetector(
            onTap: () => getIt<AudioService>().playTap(),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // TODO (Răzvan): Înlocuiește placeholder-ul cu iconița finală '${it['asset']}' din assets/images/final/
                  Image.asset('assets/images/placeholders/placeholder_square.png', width: 120, height: 120),
                  const SizedBox(height: 8),
                  Text(it['label']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ).animate().fade(duration: 350.ms).scale(curve: Curves.easeOutBack);
        },
      ),
    );
  }
}
