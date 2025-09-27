import 'package:alesia/games/instruments/xylophone_game.dart';
import 'package:alesia/features/common/hud_overlay.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class XylophoneScreen extends StatelessWidget {
  const XylophoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = XylophoneGame();
    return Scaffold(
      appBar: AppBar(title: const Text('Xilofon')),
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
