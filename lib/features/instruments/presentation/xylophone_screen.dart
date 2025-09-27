import 'package:alesia/games/instruments/xylophone_game.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

class XylophoneScreen extends StatelessWidget {
  const XylophoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Xilofon')),
      body: GameWidget(game: XylophoneGame()),
    );
  }
}
