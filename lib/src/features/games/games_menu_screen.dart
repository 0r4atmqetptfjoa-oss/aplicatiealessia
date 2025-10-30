import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumea_alessiei/l10n/app_localizations.dart';
import '../../core/widgets/rive_button.dart';
import '../../core/data_provider.dart';

class GamesMenuScreen extends ConsumerWidget {
  const GamesMenuScreen({super.key});

  String _getGameTitle(AppLocalizations? l10n, String titleKey) {
    if (l10n == null) return titleKey; // Fallback
    switch (titleKey) {
      case 'gameAlphabet':
        return l10n.gameAlphabet;
      case 'gameNumbers':
        return l10n.gameNumbers;
      case 'gamePuzzle':
        return l10n.gamePuzzle;
      default:
        return titleKey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final data = ref.watch(appDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.menuGames ?? 'Games'),
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
      body: data.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (appData) {
          final games = appData.games['games'] as List;
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/games_module/background.png"), // Placeholder
                fit: BoxFit.cover,
              ),
            ),
            child: GridView.extent(
              maxCrossAxisExtent: 300.0, // Max width for each item
              padding: const EdgeInsets.all(24),
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              children: games.map((game) {
                return RiveButton(
                  riveAsset: 'assets/rive/game_buttons.riv',
                  artboardName: game['artboard'] as String,
                  stateMachineName: 'State Machine 1',
                  onTap: () => context.go('/games/${game['id']}'),
                  label: _getGameTitle(l10n, game['title'] as String),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
