import 'package:flutter/material.dart';

class MazeGameScreen extends StatefulWidget {
  const MazeGameScreen({super.key});

  @override
  State<MazeGameScreen> createState() => _MazeGameScreenState();
}

class _MazeGameScreenState extends State<MazeGameScreen> {
  final int _rows = 10;
  final int _cols = 10;
  late List<List<int>> _maze;
  late int _playerX, _playerY;
  bool _isGameWon = false;

  @override
  void initState() {
    super.initState();
    _generateMaze();
    _playerX = 0;
    _playerY = 0;
  }

  void _generateMaze() {
    // 1 for wall, 0 for path
    _maze = [
      [0, 1, 0, 0, 0, 1, 0, 0, 0, 0],
      [0, 1, 0, 1, 0, 1, 0, 1, 1, 0],
      [0, 0, 0, 1, 0, 1, 0, 0, 0, 0],
      [0, 1, 1, 1, 0, 0, 0, 1, 1, 0],
      [0, 0, 0, 0, 0, 1, 1, 1, 0, 0],
      [1, 1, 1, 1, 0, 1, 0, 0, 0, 1],
      [0, 0, 0, 1, 0, 1, 0, 1, 0, 0],
      [0, 1, 0, 1, 0, 0, 0, 1, 1, 0],
      [0, 1, 0, 0, 0, 1, 0, 0, 0, 0],
      [0, 1, 1, 1, 1, 1, 1, 1, 1, 0],
    ];
  }

  void _movePlayer(int dx, int dy) {
    if (_isGameWon) return;

    int newX = _playerX + dx;
    int newY = _playerY + dy;

    if (newX >= 0 && newX < _cols && newY >= 0 && newY < _rows && _maze[newY][newX] == 0) {
      setState(() {
        _playerX = newX;
        _playerY = newY;
      });

      if (_playerX == _cols - 1 && _playerY == _rows - 1) {
        setState(() {
          _isGameWon = true;
        });
        _showWinDialog();
      }
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('You Won!'),
        content: const Text('Congratulations, you solved the maze!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _playerX = 0;
                _playerY = 0;
                _isGameWon = false;
              });
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
        title: const Text('Maze Game'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _cols,
              ),
              itemCount: _rows * _cols,
              itemBuilder: (context, index) {
                int row = index ~/ _cols;
                int col = index % _cols;

                if (row == _playerY && col == _playerX) {
                  return const Icon(Icons.person);
                } else if (row == _rows - 1 && col == _cols - 1) {
                  return const Icon(Icons.flag);
                } else if (_maze[row][col] == 1) {
                  return Container(color: Colors.black);
                }
                return Container(color: Colors.white);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: const Icon(Icons.arrow_upward), onPressed: () => _movePlayer(0, -1)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => _movePlayer(-1, 0)),
              const SizedBox(width: 50),
              IconButton(icon: const Icon(Icons.arrow_forward), onPressed: () => _movePlayer(1, 0)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: const Icon(Icons.arrow_downward), onPressed: () => _movePlayer(0, 1)),
            ],
          )
        ],
      ),
    );
  }
}
