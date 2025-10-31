import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PuzzleGameScreen extends StatefulWidget {
  const PuzzleGameScreen({super.key});

  @override
  State<PuzzleGameScreen> createState() => _PuzzleGameScreenState();
}

class _PuzzleGameScreenState extends State<PuzzleGameScreen> with TickerProviderStateMixin {
  late List<int> _pieces;
  int _emptyIndex = 8;
  bool _isGameWon = false;
  int _moves = 0;
  late Image _image;
  late AnimationController _winAnimationController;
  late Animation<double> _winAnimation;

  @override
  void initState() {
    super.initState();
    _image = Image.asset('assets/images/games_module/puzzle_game/puzzle.png',
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 150));
    _pieces = List.generate(9, (index) => index);
    _winAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _winAnimation = CurvedAnimation(parent: _winAnimationController, curve: Curves.bounceOut);
    _shuffle();
  }

  @override
  void dispose() {
    _winAnimationController.dispose();
    super.dispose();
  }

  void _shuffle() {
    setState(() {
      _pieces.shuffle();
      _emptyIndex = _pieces.indexOf(8);
      _isGameWon = false;
      _moves = 0;
      _winAnimationController.reset();
    });
  }

  void _movePiece(int index) {
    if (_isGameWon) return;

    if (_canMove(index)) {
      HapticFeedback.lightImpact();
      setState(() {
        _pieces[_emptyIndex] = _pieces[index];
        _pieces[index] = 8;
        _emptyIndex = index;
        _moves++;
      });
      _checkWin();
    }
  }

  bool _canMove(int index) {
    int row = index ~/ 3;
    int col = index % 3;
    int emptyRow = _emptyIndex ~/ 3;
    int emptyCol = _emptyIndex % 3;

    return (row == emptyRow && (col - emptyCol).abs() == 1) || (col == emptyCol && (row - emptyRow).abs() == 1);
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
      _winAnimationController.forward();
      _showWinDialog();
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('You Won!'),
        content: Text('You solved the puzzle in $_moves moves!'),
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
        title: const Text('Puzzle Game'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _shuffle,
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Moves: $_moves', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Center(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                children: List.generate(9, (index) {
                  int piece = _pieces[index];
                  if (piece == 8 && !_isGameWon) {
                    return Positioned(
                      left: (index % 3) * (MediaQuery.of(context).size.width / 3),
                      top: (index ~/ 3) * (MediaQuery.of(context).size.width / 3),
                      width: MediaQuery.of(context).size.width / 3,
                      height: MediaQuery.of(context).size.width / 3,
                      child: Container(color: Colors.grey[300]),
                    );
                  }
                  return AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    left: (_pieces.indexOf(piece) % 3) * (MediaQuery.of(context).size.width / 3),
                    top: (_pieces.indexOf(piece) ~/ 3) * (MediaQuery.of(context).size.width / 3),
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.width / 3,
                    child: GestureDetector(
                      onTap: () => _movePiece(_pieces.indexOf(piece)),
                      child: ScaleTransition(
                        scale: _isGameWon ? _winAnimation : const AlwaysStoppedAnimation(1.0),
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: ClipRect(
                            child: Align(
                              alignment: FractionalOffset((piece % 3) / 2.0, (piece ~/ 3) / 2.0),
                              widthFactor: 1 / 3,
                              heightFactor: 1 / 3,
                              child: _image,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
