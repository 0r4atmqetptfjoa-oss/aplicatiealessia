import 'package:alesia/games/instruments/drums_game.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

class DrumsScreen extends StatelessWidget {
  const DrumsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tobe')),
      body: GameWidget(game: DrumsGame()),
    );
  }
}
