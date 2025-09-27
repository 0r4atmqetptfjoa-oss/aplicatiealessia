import 'package:alesia/games/instruments/organ_game.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

class OrganScreen extends StatelessWidget {
  const OrganScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orgă')),
      body: GameWidget(game: OrganGame()),
    );
  }
}
