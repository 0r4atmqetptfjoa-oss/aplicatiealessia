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
        game: HomeGame(
          onNavigate: (route) => _handleNavigate(context, route),
        ),
      ),
    );
  }

  /// Wrap the navigation callback to ensure it is executed on the next
  /// microtask, avoiding any potential conflicts with Flame's internal
  /// event handling.
  void _handleNavigate(BuildContext context, String route) {
    // Use Future.microtask so the call is deferred until after the tap
    // event completes.  Without this, push/pop operations inside the
    // render loop can sometimes lead to exceptions.
    Future.microtask(() {
      // Use go_router's extension to navigate.  If go_router isn't set up
      // correctly, fall back to Navigator.  The dynamic cast allows
      // the same callback to be used from within Flame where context.go
      // isn't directly available.
      try {
        context.go(route);
      } catch (_) {
        Navigator.of(context).pushNamed(route);
      }
    });
  }
}