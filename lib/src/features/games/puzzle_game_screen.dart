import 'package:flutter/material.dart';

/// Placeholder for the puzzle game.
///
/// The final implementation will load an image, slice it into nine
/// pieces, shuffle them and allow the user to drag the pieces into a
/// 3×3 grid.  A congratulatory animation will play when the puzzle
/// is solved.  For now it displays static text to indicate the
/// feature location.
class PuzzleGameScreen extends StatelessWidget {
  const PuzzleGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: null,
      body: Center(
        child: Text('Puzzle Game Placeholder'),
      ),
    );
  }
}