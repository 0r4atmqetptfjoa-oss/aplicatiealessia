import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

/// Interactive xylophone play screen.
///
/// Displays a 3D xylophone model and a set of coloured bars. Tapping a bar
/// plays a tone and moves an animated train across the bottom of the
/// screen. The train image should be stored at `assets/images/train.png` and
/// the glb model at `assets/models/instruments/xylophone/xylophone.glb`.
class XylophonePlayScreen extends StatefulWidget {
  const XylophonePlayScreen({super.key});

  @override
  State<XylophonePlayScreen> createState() => _XylophonePlayScreenState();
}

class _XylophonePlayScreenState extends State<XylophonePlayScreen> {
  late final AudioPlayer _player;
  double _trainPosition = 0.0;
  final List<Color> _barColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  /// Play the xylophone tone and move the train.
  Future<void> _playNote() async {
    try {
      await _player.play(AssetSource('assets/audio/xylophone_note.wav'));
    } catch (_) {}
    setState(() {
      _trainPosition += 0.14;
      if (_trainPosition > 1.0) _trainPosition -= 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Xylophone')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: ModelViewer(
                src: 'assets/models/instruments/xylophone/xylophone.glb',
                alt: 'Xylophone Model',
                autoRotate: true,
                autoPlay: true,
                disableZoom: true,
                backgroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _barColors.map((color) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: _playNote,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: Stack(
                children: [
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 300),
                    alignment: Alignment(_trainPosition * 2 - 1, 0),
                    child: Image.asset(
                      'assets/images/train.png',
                      height: 80,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}