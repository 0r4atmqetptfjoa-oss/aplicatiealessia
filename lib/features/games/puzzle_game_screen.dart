import 'dart:math';

import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

/// A sliding puzzle game (8‑puzzle) implemented on a 3x3 grid.
///
/// Tiles numbered 1–8 and one blank space are shuffled. The player taps a
/// tile adjacent to the blank to slide it. When the numbers are arranged
/// in ascending order the puzzle is solved. A reset button allows the
/// player to start over.
class PuzzleGameScreen extends StatefulWidget {
  const PuzzleGameScreen({super.key});

  @override
  State<PuzzleGameScreen> createState() => _PuzzleGameScreenState();
}

class _PuzzleGameScreenState extends State<PuzzleGameScreen> {
  late List<int> _tiles;

  @override
  void initState() {
    super.initState();
    _resetPuzzle();
  }

  void _resetPuzzle() {
    _tiles = List<int>.generate(9, (i) => i); // 0 represents blank
    final random = Random();
    // Shuffle until solvable
    do {
      _tiles.shuffle(random);
    } while (!_isSolvable(_tiles));
  }

  // Check puzzle solvability using inversion count (for odd grid width)
  bool _isSolvable(List<int> list) {
    int invCount = 0;
    for (int i = 0; i < list.length - 1; i++) {
      for (int j = i + 1; j < list.length; j++) {
        if (list[i] != 0 && list[j] != 0 && list[i] > list[j]) {
          invCount++;
        }
      }
    }
    return invCount % 2 == 0;
  }

  void _onTileTap(int index) {
    final blankIndex = _tiles.indexOf(0);
    final row = index ~/ 3;
    final col = index % 3;
    final blankRow = blankIndex ~/ 3;
    final blankCol = blankIndex % 3;
    // Check if tapped tile is adjacent to blank
    if ((row == blankRow && (col - blankCol).abs() == 1) ||
        (col == blankCol && (row - blankRow).abs() == 1)) {
      setState(() {
        _tiles[blankIndex] = _tiles[index];
        _tiles[index] = 0;
      });
    }
  }

  bool get _isSolved {
    for (int i = 0; i < 8; i++) {
      if (_tiles[i] != i + 1) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Puzzle Game'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: ModelViewer(
                src: 'assets/models/puzzle/title.glb',
                alt: 'Puzzle Title',
                autoRotate: true,
                autoPlay: true,
                disableZoom: true,
                backgroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Slide the tiles to arrange them in order.',
              // subtitle1 -> titleMedium【259856227738898†L509-L519】.
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            // Puzzle grid
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  final value = _tiles[index];
                  return GestureDetector(
                    onTap: () => _onTileTap(index),
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: value == 0 ? Colors.grey.shade300 : Colors.blue.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: value == 0
                            ? const SizedBox.shrink()
                            : Text(
                                '$value',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            if (_isSolved) ...[
              Text(
                'Puzzle solved!',
                // headline5 -> headlineSmall【259856227738898†L509-L519】.
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _resetPuzzle();
                  });
                },
                child: const Text('Play Again'),
              ),
            ] else ...[
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _resetPuzzle();
                  });
                },
                child: const Text('Reset'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}