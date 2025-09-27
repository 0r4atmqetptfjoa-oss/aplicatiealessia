import 'package:alesia/games/instruments/piano_game.dart';
import 'package:alesia/features/common/hud_overlay.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class PianoScreen extends StatelessWidget {
  const PianoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = PianoGame();
    return Scaffold(
      appBar: AppBar(title: const Text('Pian')),
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
