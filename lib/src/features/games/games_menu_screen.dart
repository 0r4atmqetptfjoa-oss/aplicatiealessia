import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Menu listing educational games.
///
/// For now this screen provides simple navigation to a placeholder puzzle
/// game.  Later it can be expanded to include other games (alphabet,
/// numbers, etc.).
class GamesMenuScreen extends StatelessWidget {
  const GamesMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the available games.  Additional games can be added here.
    final games = [
      {'title': 'Alfabet', 'route': '/games/alphabet'},
      {'title': 'Numere', 'route': '/games/numbers'},
      {'title': 'Puzzle', 'route': '/games/puzzle'},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Jocuri')),
      body: ListView.builder(
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          return ListTile(
            title: Text(game['title']!),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Use GoRouter to navigate to the selected game.
              context.go(game['route']!);
            },
          );
        },
      ),
    );
  }
}