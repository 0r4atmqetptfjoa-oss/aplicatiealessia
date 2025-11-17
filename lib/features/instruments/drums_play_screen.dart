import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

/// Interactive drums play screen.
///
/// Displays a 3D drum set model and several tappable drum pads. Each pad
/// plays a percussion sound and moves an animated train across the bottom
/// of the screen. The train image should be placed in `assets/images/train.png`.
class DrumsPlayScreen extends StatefulWidget {
  const DrumsPlayScreen({super.key});

  @override
  State<DrumsPlayScreen> createState() => _DrumsPlayScreenState();
}

class _DrumsPlayScreenState extends State<DrumsPlayScreen> {
  late final AudioPlayer _player;
  double _trainPosition = 0.0;

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

  Future<void> _playDrum() async {
    try {
      await _player.play(AssetSource('assets/audio/drum_hit.wav'));
    } catch (_) {}
    setState(() {
      _trainPosition += 0.25;
      if (_trainPosition > 1.0) {
        _trainPosition -= 1.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drums')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: ModelViewer(
                src: 'assets/models/instruments/drums/drums.glb',
                alt: 'Drums Model',
                autoRotate: true,
                autoPlay: true,
                disableZoom: true,
                backgroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: List.generate(4, (index) {
                    return GestureDetector(
                      onTap: _playDrum,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.orange.shade200,
                          border: Border.all(color: Colors.brown, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            'Drum ${index + 1}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
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