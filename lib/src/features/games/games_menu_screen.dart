import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart';

class GamesMenuScreen extends StatelessWidget {
  const GamesMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final games = [
      {'title': 'Alfabet', 'route': '/games/alphabet', 'artboard': 'BTN_ALPHABET'},
      {'title': 'Numere', 'route': '/games/numbers', 'artboard': 'BTN_NUMBERS'},
      {'title': 'Puzzle', 'route': '/games/puzzle', 'artboard': 'BTN_PUZZLE'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jocuri'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => context.go('/home'),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/games_module/background.png"), // Placeholder background
            fit: BoxFit.cover,
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 24,
            crossAxisSpacing: 24,
            childAspectRatio: 1.0,
          ),
          itemCount: games.length,
          itemBuilder: (context, index) {
            final game = games[index];
            return _GameButton(
              artboard: game['artboard']!,
              onTap: () => context.go(game['route']!),
            );
          },
        ),
      ),
    );
  }
}

class _GameButton extends StatelessWidget {
  final String artboard;
  final VoidCallback onTap;

  const _GameButton({required this.artboard, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: RiveAnimation.asset(
            'assets/rive/game_buttons.riv',
            artboard: artboard,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
