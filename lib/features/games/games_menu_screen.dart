import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/subscription_service.dart';

/// Menu screen listing all available games.
///
/// This widget displays a scrollable list of games. Each list tile shows
/// an icon loaded from the assets folder along with the game title and
/// navigates to the appropriate route when tapped. The list of games is
/// declared inline for clarity, making it easy to add or remove games in the
/// future. When adding new games, be sure to also add the corresponding
/// route in [AppRouter] and place an appropriately named image in
/// `assets/images`.
class GamesMenuScreen extends StatelessWidget {
  const GamesMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access subscription status from provider
    final subscription = context.watch<SubscriptionService>();
    // Define the list of games with their titles, route paths and asset names
    final games = [
      {'title': 'Alphabet Game', 'path': 'alphabet', 'asset': 'alphabet.png'},
      {'title': 'Blocks Game', 'path': 'blocks', 'asset': 'blocks.png'},
      {'title': 'Colors Game', 'path': 'colors', 'asset': 'colors.png'},
      {'title': 'Cooking Game', 'path': 'cooking', 'asset': 'cooking.png'},
      {'title': 'Hidden Objects', 'path': 'hidden', 'asset': 'hidden_objects.png'},
      {'title': 'Instruments Game', 'path': 'instruments', 'asset': 'instruments_game.png'},
      {'title': 'Math Quiz', 'path': 'math-quiz', 'asset': 'math_quiz.png'},
      {'title': 'Maze Game', 'path': 'maze', 'asset': 'maze.png'},
      {'title': 'Memory Game', 'path': 'memory', 'asset': 'memory.png'},
      {'title': 'Numbers Game', 'path': 'numbers', 'asset': 'numbers.png'},
      {'title': 'Puzzle Game', 'path': 'puzzle', 'asset': 'puzzle.png'},
      {'title': 'Shapes Game', 'path': 'shapes', 'asset': 'shapes.png'},
      {'title': 'Sorting Animals', 'path': 'sorting-animals', 'asset': 'sorting_animals.png'},
    ];
    // Determine how many games are unlocked for non-premium users
    final accessibleCount = subscription.isPremium
        ? games.length
        : (games.length / 2).ceil();
    return Scaffold(
      appBar: AppBar(title: const Text('Games')),
      body: ListView.builder(
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          final locked = !subscription.isPremium && index >= accessibleCount;
          return _GameListTile(
            title: game['title']!,
            path: game['path']!,
            assetName: game['asset']!,
            locked: locked,
          );
        },
      ),
    );
  }
}

/// Internal widget used to build the individual game list tiles.
class _GameListTile extends StatelessWidget {
  final String title;
  final String path;
  final String assetName;
  final bool locked;

  const _GameListTile({
    required this.title,
    required this.path,
    required this.assetName,
    required this.locked,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        'assets/images/$assetName',
        width: 40,
        height: 40,
      ),
      title: Text(title),
      trailing: locked
          ? const Icon(Icons.lock)
          : const Icon(Icons.arrow_forward),
      onTap: () {
        if (locked) {
          // Navigate to paywall if the game is locked
          context.go('/paywall');
        } else {
          context.go('/games/$path');
        }
      },
    );
  }
}