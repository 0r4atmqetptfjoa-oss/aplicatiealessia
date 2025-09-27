import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

/// A simple piano game that divides a sprite into multiple tappable keys.
///
/// Each key is animated with a squash-and-stretch effect when pressed and
/// spawns a burst of star‑like particles. Audio playback and gamification
/// integration can be added via the [onPlayNote] callback.
class PianoGame extends FlameGame {
  /// Number of keys to divide the piano sprite into. Using seven keys to
  /// approximate the colors of the rainbow.
  static const int _numKeys = 7;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Load the piano sprite sheet.
    final image = await images.load('piano.png');
    final keyWidth = image.width / _numKeys;
    final keyHeight = image.height.toDouble();

    // Compute the size of each key on screen. We use 80% of the game height
    // to leave some margin at top and bottom.
    final double keyHeightDisplay = size.y * 0.8;
    final double keyWidthDisplay = size.x / _numKeys;
    final double yPos = (size.y - keyHeightDisplay) / 2;

    for (int i = 0; i < _numKeys; i++) {
      final srcPosition = Vector2(keyWidth * i, 0);
      final sprite = Sprite(
        image,
        srcPosition: srcPosition,
        srcSize: Vector2(keyWidth, keyHeight),
      );
      final key = _PianoKey(
        sprite: sprite,
        noteIndex: i,
        onPlayNote: (index) {
          // TODO: Connect to AudioEngineService to play the corresponding note.
        },
      );
      key
        ..size = Vector2(keyWidthDisplay, keyHeightDisplay)
        ..position = Vector2(i * keyWidthDisplay, yPos)
        ..anchor = Anchor.topLeft;
      add(key);
    }
  }
}

/// Represents an individual piano key component with tap effects and particles.
class _PianoKey extends SpriteComponent with TapCallbacks {
  _PianoKey({required super.sprite, required this.noteIndex, required this.onPlayNote});

  final int noteIndex;
  final void Function(int noteIndex) onPlayNote;

  final Random _random = Random();

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    // Play note callback (stubbed).
    onPlayNote(noteIndex);
    // Squash and stretch animation.
    add(ScaleEffect.to(
      Vector2(0.9, 0.95),
      EffectController(duration: 0.05, reverseDuration: 0.05),
    ));
    // Spawn star burst particles.
    _spawnParticles();
  }

  /// Spawns a small burst of star‑like particles above the key.
  void _spawnParticles() {
    const int count = 10;
    for (int i = 0; i < count; i++) {
      final velocity = Vector2((_random.nextDouble() - 0.5) * 50, -_random.nextDouble() * 80 - 20);
      final particle = ParticleComponent(
        particle: AcceleratedParticle(
          acceleration: Vector2(0, 50),
          speed: velocity,
          // Spawn at a random horizontal position along the top edge of the key.
          position: Vector2(_random.nextDouble() * size.x, 0),
          child: CircleParticle(
            radius: 3 + _random.nextDouble() * 2,
            paint: Paint()..color = Colors.white.withOpacity(0.8),
          ),
          lifespan: 1.0,
        ),
      );
      particle.priority = 10;
      add(particle);
    }
  }
}