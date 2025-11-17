import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

/// A simple blocks matching game.
///
/// Three coloured blocks must be dragged to their corresponding outlines. When
/// all blocks are placed correctly, a congratulatory message appears. A 3D
/// animated title is displayed at the top using a GLB model, with a fallback
/// animated text if the model is unavailable. This demonstrates drag‑and‑drop
/// mechanics and 3D content in Flutter.
class BlocksGameScreen extends StatefulWidget {
  const BlocksGameScreen({super.key});

  @override
  State<BlocksGameScreen> createState() => _BlocksGameScreenState();
}

class _BlocksGameScreenState extends State<BlocksGameScreen> {
  // Map to keep track of whether each colour has been matched.
  final Map<Color, bool> _matched = {
    Colors.red: false,
    Colors.blue: false,
    Colors.green: false,
  };

  void _resetGame() {
    setState(() {
      for (final key in _matched.keys) {
        _matched[key] = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blocks Game'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 3D title
            SizedBox(
              height: 150,
              child: ModelViewer(
                src: 'assets/models/blocks/title.glb',
                alt: 'Blocks Title',
                autoPlay: true,
                autoRotate: true,
                disableZoom: true,
                backgroundColor: Colors.transparent,
              ),
            ),
            // Fallback animated text
            SizedBox(
              height: 40,
              child: DefaultTextStyle(
                // Use the new Material 3 style. headline5 -> headlineSmall【259856227738898†L509-L519】.
                style: Theme.of(context).textTheme.headlineSmall!,
                child: AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    WavyAnimatedText('Drag the blocks to the outlines'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Targets row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _matched.keys.map((color) {
                return DragTarget<Color>(
                  onWillAccept: (data) => data == color,
                  onAccept: (data) {
                    setState(() {
                      _matched[color] = true;
                    });
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: color.withOpacity(0.8),
                          width: 3,
                        ),
                        color: _matched[color]! ? color.withOpacity(0.4) : null,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            // Draggable blocks row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _matched.keys.map((color) {
                return _matched[color]!
                    ? Container(
                        width: 60,
                        height: 60,
                        color: color.withOpacity(0.3),
                      )
                    : Draggable<Color>(
                        data: color,
                        feedback: Container(
                          width: 60,
                          height: 60,
                          color: color,
                        ),
                        childWhenDragging: Container(
                          width: 60,
                          height: 60,
                          color: color.withOpacity(0.3),
                        ),
                        child: Container(
                          width: 60,
                          height: 60,
                          color: color,
                        ),
                      );
              }).toList(),
            ),
            const Spacer(),
            if (_matched.values.every((matched) => matched))
              Column(
                children: [
                  Text(
                    'Great job!',
                    // headline5 replaced by headlineSmall【259856227738898†L509-L519】.
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _resetGame,
                    child: const Text('Play Again'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}