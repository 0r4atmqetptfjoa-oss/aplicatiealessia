import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:go_router/go_router.dart';

import '../../games/home_game.dart';

/// Widget representing the main menu of the Alesia app.
///
/// A Flame [GameWidget] is used here to embed a game loop inside the
/// traditional Flutter widget tree.  Navigation callbacks are passed
/// through to the [HomeGame] so that tapping a menu item triggers a route
/// change via [go_router].
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: HomeGame(),
      ),
    );
  }
}