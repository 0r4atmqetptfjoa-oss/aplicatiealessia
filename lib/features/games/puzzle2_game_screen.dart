import 'dart:math';

import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

/// A jigsaw puzzle game splitting an image into 4 tiles.
///
/// The source image (train.png) is cut into quadrants and shuffled. The player
/// swaps tiles by tapping two at a time. When the tiles are arranged
/// correctly (top‑left, top‑right, bottom‑left, bottom‑right) the puzzle is
/// solved. The user can reset the puzzle at any time.
class Puzzle2GameScreen extends StatefulWidget {
  const Puzzle2GameScreen({super.key});

  @override
  State<Puzzle2GameScreen> createState() => _Puzzle2GameScreenState();
}

class _Puzzle2GameScreenState extends State<Puzzle2GameScreen> {
  late List<int> _order; // indices 0-3 representing positions
  int? _firstTap;

  @override
  void initState() {
    super.initState();
    _reset();
  }

  void _reset() {
    _order = [0, 1, 2, 3];
    final random = Random();
    _order.shuffle(random);
    // Ensure it's not initially solved
    if (_isSolved) {
      _order.shuffle(random);
    }
    _firstTap = null;
    setState(() {});
  }

  bool get _isSolved =>
      _order.length == 4 &&
      _order[0] == 0 &&
      _order[1] == 1 &&
      _order[2] == 2 &&
      _order[3] == 3;

  void _onTileTap(int index) {
    if (_firstTap == null) {
      setState(() {
        _firstTap = index;
      });
    } else {
      final first = _firstTap!;
      if (first != index) {
        setState(() {
          final temp = _order[first];
          _order[first] = _order[index];
          _order[index] = temp;
        });
      }
      setState(() {
        _firstTap = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Puzzle 2 Game'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: ModelViewer(
                src: 'assets/models/puzzle/title.glb',
                alt: 'Puzzle 2 Title',
                autoRotate: true,
                autoPlay: true,
                disableZoom: true,
                backgroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Swap the tiles to complete the picture.',
              // subtitle1 -> titleMedium【259856227738898†L509-L519】.
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            // 2x2 grid of tiles
            Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        _buildTile(0),
                        _buildTile(1),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        _buildTile(2),
                        _buildTile(3),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (_isSolved) ...[
              Text('Puzzle complete!',
                  // headline6 -> titleLarge【259856227738898†L509-L519】.
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
            ],
            ElevatedButton(
              onPressed: _reset,
              child: Text(_isSolved ? 'Play Again' : 'Reset'),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a tile at a given index (0–3). The tile uses an [Align]
  /// widget with widthFactor and heightFactor of 0.5 to crop the image
  /// accordingly. The [alignment] values correspond to the positions of
  /// the quadrants: (-1, -1) top‑left, (1, -1) top‑right, (-1, 1)
  /// bottom‑left, (1, 1) bottom‑right. Tapping two tiles swaps them.
  Widget _buildTile(int position) {
    final segment = _order[position];
    Alignment alignment;
    switch (segment) {
      case 0:
        alignment = const Alignment(-1, -1);
        break;
      case 1:
        alignment = const Alignment(1, -1);
        break;
      case 2:
        alignment = const Alignment(-1, 1);
        break;
      case 3:
        alignment = const Alignment(1, 1);
        break;
      default:
        alignment = Alignment.center;
        break;
    }
    final isSelected = _firstTap == position;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onTileTap(position),
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.red : Colors.black,
              width: isSelected ? 3 : 1,
            ),
          ),
          child: ClipRect(
            child: Align(
              alignment: alignment,
              widthFactor: 0.5,
              heightFactor: 0.5,
              child: Image.asset(
                'assets/images/train.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}