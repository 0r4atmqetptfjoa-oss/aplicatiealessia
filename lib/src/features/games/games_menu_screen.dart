import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumea_alessiei/l10n/app_localizations.dart';
import 'package:lumea_alessiei/src/core/data_provider.dart';

// Helper pentru a obține traducerea
String _getTranslatedTitle(BuildContext context, String key) {
  final l10n = AppLocalizations.of(context);
  switch (key) {
    case 'gameAlphabet': return l10n.gameAlphabet;
    case 'gameNumbers': return l10n.gameNumbers;
    case 'gamePuzzle': return l10n.gamePuzzle;
    case 'gameMemory': return l10n.gameMemory;
    case 'gameShapes': return l10n.gameShapes;
    case 'gameColors': return l10n.gameColors;
    case 'gameMathQuiz': return l10n.gameMathQuiz;
    case 'gamePuzzle2': return l10n.gamePuzzle2;
    case 'gameInstruments': return l10n.gameInstruments;
    case 'gameSortingAnimals': return l10n.gameSortingAnimals;
    case 'gameCooking': return l10n.gameCooking;
    case 'gameMaze': return l10n.gameMaze;
    case 'gameHiddenObjects': return l10n.gameHiddenObjects;
    case 'gameBlocks': return l10n.gameBlocks;
    default: return key; // Fallback
  }
}

class GamesMenuScreen extends ConsumerWidget {
  const GamesMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final data = ref.watch(appDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.menuGames),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: data.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (appData) {
          final games = appData.games['games'] as List;
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/games_module/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: GridView.builder(
              padding: const EdgeInsets.all(24.0),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.0,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                return ElevatedButton(
                  onPressed: () => context.go('/games/${game['id']}'),
                  child: Text(
                    _getTranslatedTitle(context, game['title'] as String),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
