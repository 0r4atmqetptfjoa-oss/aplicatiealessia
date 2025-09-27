import 'package:alesia/games/instruments/organ_game.dart';
import 'package:alesia/features/common/hud_overlay.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class OrganScreen extends StatelessWidget {
  const OrganScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = OrganGame();
    return Scaffold(
      appBar: AppBar(title: const Text('Orgă')),
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
