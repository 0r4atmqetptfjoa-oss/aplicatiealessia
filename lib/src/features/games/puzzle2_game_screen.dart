import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class Puzzle2GameScreen extends StatefulWidget {
  const Puzzle2GameScreen({super.key});

  @override
  State<Puzzle2GameScreen> createState() => _Puzzle2GameScreenState();
}

class _Puzzle2GameScreenState extends State<Puzzle2GameScreen> {
  final int _gridSize = 4;
  late List<int> _pieces;
  late int _emptyIndex;
  bool _isGameWon = false;
  late Image _image;

  @override
  void initState() {
    super.initState();
    _image = Image.asset('assets/images/games_module/puzzle_game/puzzle2.png',
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 150));
    _pieces = List.generate(_gridSize * _gridSize, (index) => index);
    _shuffle();
  }

  void _shuffle() {
    setState(() {
      _pieces.shuffle();
      _emptyIndex = _pieces.indexOf(15);
      _isGameWon = false;
    });
  }

  void _movePiece(int index) {
    if (_isGameWon) return;

    if (_canMove(index)) {
      setState(() {
        _pieces[_emptyIndex] = _pieces[index];
        _pieces[index] = 15;
        _emptyIndex = index;
      });
      _checkWin();
    }
  }

  bool _canMove(int index) {
    int row = index ~/ _gridSize;
    int col = index % _gridSize;
    int emptyRow = _emptyIndex ~/ _gridSize;
    int emptyCol = _emptyIndex % _gridSize;

    return (row == emptyRow && (col - emptyCol).abs() == 1) ||
           (col == emptyCol && (row - emptyRow).abs() == 1);
  }

  void _checkWin() {
    bool isSorted = true;
    for (int i = 0; i < _pieces.length; i++) {
      if (_pieces[i] != i) {
        isSorted = false;
        break;
      }
    }
    if (isSorted) {
      setState(() {
        _isGameWon = true;
      });
      _showWinDialog();
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('You Won!'),
        content: const Text('Congratulations, you solved the puzzle!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _shuffle();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Puzzle Game 4x4'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _shuffle,
          )
        ],
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 1.0,
          child: GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _gridSize,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            ),
            itemCount: _gridSize * _gridSize,
            itemBuilder: (context, index) {
              int piece = _pieces[index];
              if (piece == 15) {
                return Container(color: Colors.grey[300]);
              }
              return GestureDetector(
                onTap: () => _movePiece(index),
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: ClipRect(
                    child: Align(
                      alignment: FractionalOffset(
                        (piece % _gridSize) / (_gridSize - 1),
                        (piece ~/ _gridSize) / (_gridSize - 1),
                      ),
                      widthFactor: 1 / _gridSize,
                      heightFactor: 1 / _gridSize,
                      child: _image,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
