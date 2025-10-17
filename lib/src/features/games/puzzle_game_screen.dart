import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A simple drag‑and‑drop puzzle game.
///
/// This screen loads a single image from the `assets/images/games_module`
/// folder (`puzzle_1.png`), slices it into a 3×3 grid and allows the
/// child to drag each piece into the correct slot.  When all nine pieces
/// are placed in their correct positions a congratulatory message
/// appears.  Pieces can be moved freely between the palette and the board.
class PuzzleGameScreen extends StatefulWidget {
  const PuzzleGameScreen({super.key});

  @override
  State<PuzzleGameScreen> createState() => _PuzzleGameScreenState();
}

class _PuzzleGameScreenState extends State<PuzzleGameScreen> {
  // Each board cell holds the index of the piece currently placed there
  // or null if the cell is empty.  There are nine cells (3×3 grid).
  final List<int?> _board = List<int?>.filled(9, null);

  // The list of piece indices that are not yet placed on the board.
  late List<int> _palette;

  @override
  void initState() {
    super.initState();
    // Initialize the palette with all nine pieces in random order.
    _palette = List<int>.generate(9, (i) => i);
    _palette.shuffle();
  }

  /// Returns true if all board cells contain the correct piece.
  bool _isSolved() {
    for (int i = 0; i < _board.length; i++) {
      final piece = _board[i];
      if (piece != i) return false;
    }
    return true;
  }

  /// Handles dropping a piece onto a board cell.
  void _handleDrop(int cellIndex, int pieceIndex) {
    setState(() {
      // Remove the piece from the palette if it's there.
      _palette.remove(pieceIndex);
      // Remove the piece from its previous board location, if any.
      final oldIndex = _board.indexOf(pieceIndex);
      if (oldIndex != -1) {
        _board[oldIndex] = null;
      }
      // If this cell already contains a piece, return that piece to the palette.
      final existing = _board[cellIndex];
      if (existing != null) {
        _palette.add(existing);
      }
      // Place the new piece into this cell.
      _board[cellIndex] = pieceIndex;
    });
    // After placing a piece, check if the puzzle is solved.
    if (_isSolved()) {
      // Show a simple congratulatory dialog.  In a later phase you can
      // replace this with a Rive animation or another celebration.
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: const Text('Felicitări!'),
              content: const Text('Ai completat puzzle‑ul!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      });
    }
  }

  /// Handles dropping a piece back into the palette.
  void _handlePaletteDrop(int pieceIndex) {
    setState(() {
      // Remove from its board location, if any.
      final oldIndex = _board.indexOf(pieceIndex);
      if (oldIndex != -1) {
        _board[oldIndex] = null;
      }
      // Only add to palette if it's not already there.
      if (!_palette.contains(pieceIndex)) {
        _palette.add(pieceIndex);
      }
    });
  }

  /// Builds a tile widget that displays part of the full image.  The
  /// [pieceIndex] determines which of the 9 regions to show.  The
  /// [tileSize] controls the size of the returned widget.  When
  /// dragged, the feedback also uses the same tile size.
  Widget _buildTile(int pieceIndex, double tileSize) {
    // Compute row and column from the piece index.
    final row = pieceIndex ~/ 3;
    final col = pieceIndex % 3;
    // Alignment values run from -1 to 1.  For three divisions the
    // positions are -1, 0 and 1.
    final double alignX = -1.0 + col * 1.0;
    final double alignY = -1.0 + row * 1.0;
    return SizedBox(
      width: tileSize,
      height: tileSize,
      child: ClipRect(
        child: Align(
          alignment: Alignment(alignX, alignY),
          widthFactor: 1 / 3,
          heightFactor: 1 / 3,
          child: Image.asset(
            'assets/images/games_module/puzzle_1.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // The layout adapts to the available size using LayoutBuilder.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzle'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/games'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => context.go('/home'),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double boardSize = math.min(
            constraints.maxWidth * 0.7,
            constraints.maxHeight * 0.7,
          );
          final double tileSize = boardSize / 3;
          return Row(
            children: [
              // Puzzle board on the left
              Container(
                width: boardSize,
                height: boardSize,
                padding: const EdgeInsets.all(8),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, cellIndex) {
                    final pieceIndex = _board[cellIndex];
                    return DragTarget<int>(
                      onWillAccept: (data) => true,
                      onAccept: (pieceIndex) {
                        _handleDrop(cellIndex, pieceIndex);
                      },
                      builder: (context, candidateData, rejectedData) {
                        if (pieceIndex == null) {
                          // Empty cell – draw a placeholder border.
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                          );
                        } else {
                          // Wrap the tile in a Draggable so it can be moved again.
                          return Draggable<int>(
                            data: pieceIndex,
                            feedback: Material(
                              color: Colors.transparent,
                              child: _buildTile(pieceIndex, tileSize),
                            ),
                            childWhenDragging: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                border: Border.all(color: Colors.grey.shade400),
                              ),
                            ),
                            child: _buildTile(pieceIndex, tileSize),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
              // Palette on the right: remaining pieces
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'Piese disponibile',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Palette area acts as a drag target for returning pieces.
                      Expanded(
                        child: DragTarget<int>(
                          onWillAccept: (data) => true,
                          onAccept: (pieceIndex) {
                            _handlePaletteDrop(pieceIndex);
                          },
                          builder: (context, candidateData, rejectedData) {
                            return SingleChildScrollView(
                              child: Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: _palette.map((pieceIndex) {
                                  return Draggable<int>(
                                    data: pieceIndex,
                                    feedback: Material(
                                      color: Colors.transparent,
                                      child: _buildTile(pieceIndex, tileSize),
                                    ),
                                    childWhenDragging: Container(
                                      width: tileSize,
                                      height: tileSize,
                                    ),
                                    child: _buildTile(pieceIndex, tileSize),
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}