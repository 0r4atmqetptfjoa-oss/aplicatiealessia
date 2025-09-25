import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A simple drag‑and‑drop puzzle game using four pieces.
///
/// The puzzle image is split into four quadrants.  The pieces start
/// randomly positioned at the bottom of the screen and can be dragged
/// onto their correct locations.  When all pieces are placed the
/// completed image is visible.
class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({super.key});

  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  final List<String> _piecePaths = [
    'assets/images/games/puzzle/piece_0.png',
    'assets/images/games/puzzle/piece_1.png',
    'assets/images/games/puzzle/piece_2.png',
    'assets/images/games/puzzle/piece_3.png',
  ];
  final Map<int, Offset> _pieceOffsets = {};
  final Map<int, int?> _pieceSlot = {};
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _initPositions();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  void _initPositions() {
    // Initial offsets will be randomised within a lower portion of the screen.
    for (int i = 0; i < _piecePaths.length; i++) {
      _pieceSlot[i] = null;
      _pieceOffsets[i] = Offset.zero;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzle'),
        leading: BackButton(onPressed: () => Navigator.of(context).pop()),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double boardSize = constraints.maxWidth - 32.0;
          final double cellSize = boardSize / 2;
          final double boardTop = 16.0;
          final double boardLeft = 16.0;
          // Determine random starting positions if they are zero.
          for (int i = 0; i < _pieceOffsets.length; i++) {
            if (_pieceOffsets[i] == Offset.zero) {
              final double x = boardLeft + _random.nextDouble() * (boardSize - cellSize);
              final double y = boardTop + boardSize + 40 + _random.nextDouble() * 100;
              _pieceOffsets[i] = Offset(x, y);
            }
          }
          return Stack(
            children: [
              // Draw drop targets
              for (int slot = 0; slot < 4; slot++)
                Positioned(
                  left: boardLeft + (slot % 2) * cellSize,
                  top: boardTop + (slot ~/ 2) * cellSize,
                  width: cellSize,
                  height: cellSize,
                  child: DragTarget<int>(
                    onWillAccept: (data) => data != null && _pieceSlot[data] == null,
                    onAccept: (data) {
                      setState(() {
                        _pieceSlot[data] = slot;
                        // Snap piece to slot center
                        _pieceOffsets[data] = Offset(
                          boardLeft + (slot % 2) * cellSize,
                          boardTop + (slot ~/ 2) * cellSize,
                        );
                      });
                    },
                    builder: (context, candidateData, rejectedData) {
                      final bool occupied = _pieceSlot.containsValue(slot);
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.circular(4),
                          color: occupied ? Colors.transparent : Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              // Draggable pieces not yet placed
              for (int i = 0; i < _piecePaths.length; i++)
                if (_pieceSlot[i] == null)
                  Positioned(
                    left: _pieceOffsets[i]!.dx,
                    top: _pieceOffsets[i]!.dy,
                    width: cellSize,
                    height: cellSize,
                    child: Draggable<int>(
                      data: i,
                      onDragEnd: (details) {
                        setState(() {
                          _pieceOffsets[i] = details.offset;
                        });
                      },
                      feedback: SizedBox(
                        width: cellSize,
                        height: cellSize,
                        child: Image.asset(_piecePaths[i]),
                      ),
                      childWhenDragging: const SizedBox.shrink(),
                      child: Image.asset(_piecePaths[i]),
                    ),
                  ),
              // Pieces placed in slots
              for (int i = 0; i < _piecePaths.length; i++)
                if (_pieceSlot[i] != null)
                  Positioned(
                    left: boardLeft + (_pieceSlot[i]! % 2) * cellSize,
                    top: boardTop + (_pieceSlot[i]! ~/ 2) * cellSize,
                    width: cellSize,
                    height: cellSize,
                    child: Image.asset(_piecePaths[i]),
                  ),
              // Completed overlay
              if (_pieceSlot.values.every((slot) => slot != null))
                Positioned(
                  left: boardLeft,
                  top: boardTop,
                  width: boardSize,
                  height: boardSize,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green, width: 4),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.check_circle, color: Colors.green, size: 64),
                          SizedBox(height: 8),
                          Text('Felicitări!', style: TextStyle(fontSize: 24)),
                        ],
                      ),
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