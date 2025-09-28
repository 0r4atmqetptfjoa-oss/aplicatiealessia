import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/progress_service.dart';
import 'package:flutter/material.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = getIt<ProgressService>();
    final stickers = progress.stickers.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recompense'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: stickers.length,
        itemBuilder: (context, index) {
          final stickerId = stickers[index];
          return Card(
            child: Center(
              child: Text(stickerId), // Placeholder
              // TODO (Răzvan): Înlocuiește cu sprite sticker final 'assets/images/final/<id>.png'
            ),
          );
        },
      ),
    );
  }
}