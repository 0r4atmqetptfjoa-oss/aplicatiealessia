import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/progress_service.dart';
import 'package:flutter/material.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = getIt<ProgressService>();
    final entries = progress.stickers.entries.toList()..sort((a,b)=>a.key.compareTo(b.key));
    return Scaffold(
      appBar: AppBar(title: const Text('Colecție Stickere')),
      body: entries.isEmpty
          ? const Center(child: Text('Nicio recompensă încă. Joacă-te pentru a câștiga stickere!'))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: entries.length,
              itemBuilder: (context, i) {
                final e = entries[i];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // TODO (Răzvan): Înlocuiește placeholder-ul cu iconul final pentru sticker '${e.key}.png'
                      Image.asset('assets/images/placeholders/placeholder_square.png', width: 72, height: 72),
                      const SizedBox(height: 8),
                      Text(e.key, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      Text('x${e.value}', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
