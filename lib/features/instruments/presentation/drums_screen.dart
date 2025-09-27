import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flame/game.dart';

import '../../../games/instruments/drums_game.dart';

/// Screen for the drums instrument module. Forces landscape orientation while
/// the game is running and restores portrait when disposed.
class DrumsScreen extends StatefulWidget {
  const DrumsScreen({super.key});

  @override
  State<DrumsScreen> createState() => _DrumsScreenState();
}

class _DrumsScreenState extends State<DrumsScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GameWidget(game: DrumsGame()),
          Positioned(
            top: 16,
            left: 16,
            child: SafeArea(
              child: FloatingActionButton(
                mini: true,
                heroTag: 'back_drums',
                onPressed: () => GoRouter.of(context).pop(),
                child: const Icon(Icons.arrow_back),
              ),
            ),
          ),
        ],
      ),
    );
  }
}