import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PuzzleGameScreen extends StatefulWidget {
  const PuzzleGameScreen({super.key});

  @override
  State<PuzzleGameScreen> createState() => _PuzzleGameScreenState();
}

class _PuzzleGameScreenState extends State<PuzzleGameScreen> {
  int _gridSize = 3;
  late List<int?> _board;
  late List<int> _palette;
  bool _showHint = false;
  Timer? _timer;
  int _secondsElapsed = 0;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    final totalPieces = _gridSize * _gridSize;
    _board = List<int?>.filled(totalPieces, null);
    _palette = List<int>.generate(totalPieces, (i) => i)..shuffle();
    _secondsElapsed = 0;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _secondsElapsed++;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool _isSolved() {
    for (int i = 0; i < _board.length; i++) {
      if (_board[i] != i) return false;
    }
    return true;
  }

  void _handleDrop(int cellIndex, int pieceIndex) {
    setState(() {
      _palette.remove(pieceIndex);
      final oldIndex = _board.indexOf(pieceIndex);
      if (oldIndex != -1) _board[oldIndex] = null;

      final existing = _board[cellIndex];
      if (existing != null) _palette.add(existing);

      _board[cellIndex] = pieceIndex;
    });

    if (_isSolved()) {
      _timer?.cancel();
      _showSuccessDialog();
    }
  }

  void _handlePaletteDrop(int pieceIndex) {
    setState(() {
      final oldIndex = _board.indexOf(pieceIndex);
      if (oldIndex != -1) _board[oldIndex] = null;
      if (!_palette.contains(pieceIndex)) _palette.add(pieceIndex);
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Congratulations!'),
        content: Text('You solved the puzzle in $_secondsElapsed seconds!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                if (_gridSize < 5) _gridSize++; // Increase difficulty
                _initializeGame();
              });
            },
            child: const Text('Next Level'),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(int pieceIndex, double tileSize) {
    final row = pieceIndex ~/ _gridSize;
    final col = pieceIndex % _gridSize;
    final alignX = -1.0 + (col * 2.0 / (_gridSize - 1));
    final alignY = -1.0 + (row * 2.0 / (_gridSize - 1));

    return SizedBox(
      width: tileSize,
      height: tileSize,
      child: ClipRect(
        child: Align(
          alignment: Alignment(alignX, alignY),
          widthFactor: 1 / _gridSize,
          heightFactor: 1 / _gridSize,
          child: Image.asset('assets/images/games_module/puzzle_1.png', fit: BoxFit.cover),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Puzzle Game ($_gridSize x $_gridSize)'),
        actions: [
          IconButton(
            icon: Icon(_showHint ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _showHint = !_showHint),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() => _initializeGame()),
          ),
          GoRouter.of(context).canPop() ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()) : const SizedBox.shrink(),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final boardSize = math.min(constraints.maxWidth * 0.7, constraints.maxHeight * 0.9);
          final tileSize = boardSize / _gridSize;

          return Row(
            children: [
              Container(
                width: boardSize,
                height: boardSize,
                child: Stack(
                  children: [
                    if (_showHint)
                      Opacity(
                        opacity: 0.2,
                        child: Image.asset('assets/images/games_module/puzzle_1.png', fit: BoxFit.cover),
                      ),
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _gridSize,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemCount: _gridSize * _gridSize,
                      itemBuilder: (context, cellIndex) {
                        final pieceIndex = _board[cellIndex];
                        return DragTarget<int>(
                          onAccept: (data) => _handleDrop(cellIndex, data),
                          builder: (context, candidateData, rejectedData) {
                            if (pieceIndex == null) {
                              return Container(color: Colors.grey.withOpacity(0.1));
                            } else {
                              return Draggable<int>(
                                data: pieceIndex,
                                feedback: _buildTile(pieceIndex, tileSize),
                                childWhenDragging: const SizedBox.shrink(),
                                child: _buildTile(pieceIndex, tileSize),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: DragTarget<int>(
                  onAccept: (data) => _handlePaletteDrop(data),
                  builder: (context, candidateData, rejectedData) {
                    return SingleChildScrollView(
                      child: Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: _palette.map((pieceIndex) {
                          return Draggable<int>(
                            data: pieceIndex,
                            feedback: _buildTile(pieceIndex, tileSize),
                            childWhenDragging: const SizedBox.shrink(),
                            child: _buildTile(pieceIndex, tileSize),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
