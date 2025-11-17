import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

/// Interactive piano play screen.
///
/// This screen displays a 3D piano model at the top and a simple keyboard
/// below. Tapping a key plays a short tone and triggers an animation of a
/// train with characters moving across the bottom of the screen. The train
/// image should be placed at `assets/images/train.png`. 3D models can be
/// supplied under `assets/models/instruments/piano/piano.glb`.
class PianoPlayScreen extends StatefulWidget {
  const PianoPlayScreen({super.key});

  @override
  State<PianoPlayScreen> createState() => _PianoPlayScreenState();
}

class _PianoPlayScreenState extends State<PianoPlayScreen> with SingleTickerProviderStateMixin {
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

  /// Play a note and advance the train animation.
  Future<void> _playNote() async {
    try {
      await _player.play(AssetSource('assets/audio/piano_note.wav'));
    } catch (_) {
      // ignore errors if file missing
    }
    setState(() {
      _trainPosition += 0.2;
      if (_trainPosition > 1.0) {
        _trainPosition -= 1.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Piano')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 3D piano model
            SizedBox(
              height: 200,
              child: ModelViewer(
                src: 'assets/models/instruments/piano/piano.glb',
                alt: 'Piano Model',
                autoRotate: true,
                autoPlay: true,
                disableZoom: true,
                backgroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 16),
            // Simple piano keyboard: 7 white keys
            Expanded(
              child: Row(
                children: List.generate(7, (index) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: _playNote,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const SizedBox.expand(),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
            // Animated train at the bottom
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