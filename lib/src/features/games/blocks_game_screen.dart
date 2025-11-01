import 'dart:ui';

import 'package:flutter/material.dart';

class BlocksGameScreen extends StatefulWidget {
  const BlocksGameScreen({super.key});

  @override
  State<BlocksGameScreen> createState() => _BlocksGameScreenState();
}

class _BlocksGameScreenState extends State<BlocksGameScreen> {
  final List<Block> _stackedBlocks = [];
  final List<Color> _blockColors = [Colors.red, Colors.green, Colors.blue, Colors.yellow, Colors.orange];

  void _onBlockDropped(Block block) {
    setState(() {
      _stackedBlocks.add(block);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blocks Game'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() => _stackedBlocks.clear()),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: DragTarget<Block>(
              builder: (context, candidateData, rejectedData) {
                return Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: _stackedBlocks.map((block) => block.widget).toList(),
                    ),
                  ),
                );
              },
              onAccept: _onBlockDropped,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.brown[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _blockColors.map((color) {
                  final block = Block(color: color, size: const Size(60, 60));
                  return Draggable<Block>(
                    data: block,
                    feedback: block.widget,
                    childWhenDragging: Container(),
                    child: block.widget,
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Block {
  final Color color;
  final Size size;

  Block({required this.color, required this.size});

  Widget get widget {
    return Container(
      width: size.width,
      height: size.height,
      color: color,
      margin: const EdgeInsets.all(4.0),
    );
  }
}
