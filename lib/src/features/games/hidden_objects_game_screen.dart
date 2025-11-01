import 'dart:ui';

import 'package:flutter/material.dart';

class HiddenObjectsGameScreen extends StatefulWidget {
  const HiddenObjectsGameScreen({super.key});

  @override
  State<HiddenObjectsGameScreen> createState() => _HiddenObjectsGameScreenState();
}

class _HiddenObjectsGameScreenState extends State<HiddenObjectsGameScreen> {
  final List<HiddenObject> _objects = [
    HiddenObject(name: 'apple', path: 'apple.png', position: const Offset(100, 200), size: const Size(40, 40)),
    HiddenObject(name: 'ball', path: 'ball.png', position: const Offset(250, 300), size: const Size(50, 50)),
    HiddenObject(name: 'star', path: 'star.png', position: const Offset(50, 50), size: const Size(30, 30)),
    HiddenObject(name: 'key', path: 'key.png', position: const Offset(180, 120), size: const Size(60, 30)),
  ];

  void _onObjectFound(HiddenObject object) {
    if (!object.isFound) {
      setState(() {
        object.isFound = true;
      });

      if (_objects.every((obj) => obj.isFound)) {
        _showWinDialog();
      }
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('You Won!'),
        content: const Text('Congratulations, you found all the hidden objects!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                for (var obj in _objects) {
                  obj.isFound = false;
                }
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
        title: const Text('Hidden Objects Game'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/games_module/hidden_objects_game/scene.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) => const Center(child: Text('Scene image not found')),
                ),
                ..._objects.map((object) {
                  return Positioned(
                    left: object.position.dx,
                    top: object.position.dy,
                    width: object.size.width,
                    height: object.size.height,
                    child: GestureDetector(
                      onTap: () => _onObjectFound(object),
                      child: object.isFound
                          ? Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.green, width: 3),
                                shape: BoxShape.circle,
                              ),
                            )
                          : Image.asset(
                              'assets/images/games_module/hidden_objects_game/${object.path}',
                              errorBuilder: (context, error, stackTrace) => Container(), // Hide if image not found
                            ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _objects.map((object) {
                return Text(
                  object.name,
                  style: TextStyle(
                    fontSize: 18,
                    decoration: object.isFound ? TextDecoration.lineThrough : null,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class HiddenObject {
  final String name;
  final String path;
  final Offset position;
  final Size size;
  bool isFound;

  HiddenObject({
    required this.name,
    required this.path,
    required this.position,
    required this.size,
    this.isFound = false,
  });
}
