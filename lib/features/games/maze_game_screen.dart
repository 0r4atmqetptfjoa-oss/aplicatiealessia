import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

/// A simple maze game implemented on a 2D grid.
///
/// The player moves a red square through a maze to reach the green goal
/// square using directional buttons. Walls block movement. When the goal
/// is reached, a success message appears along with a restart button.
class MazeGameScreen extends StatefulWidget {
  const MazeGameScreen({super.key});

  @override
  State<MazeGameScreen> createState() => _MazeGameScreenState();
}

class _MazeGameScreenState extends State<MazeGameScreen> {
  // Define a simple 5x5 maze where true indicates a wall.
  final List<List<bool>> _walls = [
    [false, true, false, false, false],
    [false, true, false, true, false],
    [false, false, false, true, false],
    [true, false, true, false, false],
    [false, false, false, false, false],
  ];

  final _goal = const Offset(4, 4);
  Offset _player = const Offset(0, 0);

  void _move(int dx, int dy) {
    final newPos = Offset(_player.dx + dx, _player.dy + dy);
    if (newPos.dx < 0 || newPos.dx >= _walls.length || newPos.dy < 0 || newPos.dy >= _walls.first.length) {
      return; // out of bounds
    }
    if (_walls[newPos.dx.toInt()][newPos.dy.toInt()]) {
      return; // hit a wall
    }
    setState(() {
      _player = newPos;
    });
  }

  void _reset() {
    setState(() {
      _player = const Offset(0, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final reachedGoal = _player == _goal;
    return Scaffold(
      appBar: AppBar(title: const Text('Maze Game'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: ModelViewer(
                src: 'assets/models/maze/title.glb',
                alt: 'Maze Title',
                autoRotate: true,
                autoPlay: true,
                disableZoom: true,
                backgroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 16),
            // Maze grid
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                ),
                itemCount: 25,
                itemBuilder: (context, index) {
                  final row = index ~/ 5;
                  final col = index % 5;
                  final isWall = _walls[row][col];
                  final pos = Offset(row.toDouble(), col.toDouble());
                  Color color;
                  if (pos == _player) {
                    color = Colors.red;
                  } else if (pos == _goal) {
                    color = Colors.green;
                  } else if (isWall) {
                    color = Colors.black;
                  } else {
                    color = Colors.white;
                  }
                  return Container(
                    margin: const EdgeInsets.all(1),
                    color: color,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Control buttons
            if (!reachedGoal) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_upward),
                    onPressed: () => _move(-1, 0),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => _move(0, -1),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () => _move(0, 1),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_downward),
                    onPressed: () => _move(1, 0),
                  ),
                ],
              ),
            ] else ...[
              Text(
                'You reached the goal!',
                // headline6 -> titleLarge【259856227738898†L509-L519】.
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _reset,
                child: const Text('Play Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}