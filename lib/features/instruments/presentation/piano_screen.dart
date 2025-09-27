import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flame/game.dart';

import '../../../games/instruments/piano_game.dart';

/// A screen that hosts the PianoGame and forces landscape orientation while
/// playing. When disposed, it restores portrait orientation.
class PianoScreen extends StatefulWidget {
  const PianoScreen({super.key});

  @override
  State<PianoScreen> createState() => _PianoScreenState();
}

class _PianoScreenState extends State<PianoScreen> {
  @override
  void initState() {
    super.initState();
    // Force landscape orientation when entering the screen.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Restore portrait orientation when leaving the screen.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The background color helps the parallax edges blend nicely.
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Game content fills the entire screen.
          GameWidget(game: PianoGame()),
          // A small overlay with a back button in the top‑left corner.
          Positioned(
            top: 16,
            left: 16,
            child: SafeArea(
              child: FloatingActionButton(
                mini: true,
                heroTag: 'back_piano',
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