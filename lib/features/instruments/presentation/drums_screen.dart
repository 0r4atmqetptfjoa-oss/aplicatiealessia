import 'package:alesia/games/instruments/drums_game.dart';
import 'package:alesia/features/common/hud_overlay.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class DrumsScreen extends StatelessWidget {
  const DrumsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = DrumsGame();
    return Scaffold(
      appBar: AppBar(title: const Text('Tobe')),
      body: GameWidget(
        game: game,
        overlayBuilderMap: {
          'hud': (context, _) => HudOverlay(game: game),
        },
        initialActiveOverlays: const ['hud'],
      ),
    );
  }
}
