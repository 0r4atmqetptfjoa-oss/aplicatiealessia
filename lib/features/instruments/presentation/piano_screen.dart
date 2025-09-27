import 'package:alesia/games/instruments/piano_game.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

class PianoScreen extends StatelessWidget {
  const PianoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pian')),
      body: GameWidget(game: PianoGame()),
    );
  }
}
