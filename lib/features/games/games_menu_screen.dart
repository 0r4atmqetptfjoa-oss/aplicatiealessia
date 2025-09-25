import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Top‑level menu for the games section.
///
/// Presents three Pixar‑styled buttons allowing the child to choose
/// between the alphabet, memory, and puzzle games.
class GamesMenuScreen extends StatelessWidget {
  const GamesMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        title: 'Alfabet',
        route: '/games/alphabet',
        asset: 'assets/images/games/alphabet/letter_a.png',
      ),
      (
        title: 'Memorie',
        route: '/games/memory',
        asset: 'assets/images/games/memory/pig.png',
      ),
      (
        title: 'Puzzle',
        route: '/games/puzzle',
        asset: 'assets/images/games/puzzle/puzzle_icon.png',
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jocuri'),
        leading: BackButton(onPressed: () => Navigator.of(context).pop()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: items.map((item) {
            return GestureDetector(
              onTap: () => context.go(item.route),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Image.asset(item.asset),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}