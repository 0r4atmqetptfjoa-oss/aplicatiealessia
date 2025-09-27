import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'home_game.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(game: HomeGame()),
    );
  }
}
