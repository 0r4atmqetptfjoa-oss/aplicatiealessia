import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
// Import the particles library to gain access to AcceleratedParticle,
// CircleParticle and other particle-related classes. Without this
// import, these types will not be available when using newer versions
// of Flame (1.23+), leading to compilation errors.
import 'package:flame/particles.dart';
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

    // Determine the display size for each key while preserving aspect ratio of
    // the original sprite. We allocate 80% of the vertical space for the
    // keys. Based on that height and the key ratio, we compute the ideal
    // width. If the total ideal width exceeds the available horizontal space,
    // we scale down to fit horizontally, adjusting the height accordingly.
    final double availableHeight = size.y * 0.8;
    final double keyRatio = keyWidth / keyHeight;
    // Ideal width per key based on height.
    final double idealKeyWidth = availableHeight * keyRatio;
    final double totalIdealWidth = idealKeyWidth * _numKeys;
    late double keyWidthDisplay;
    late double keyHeightDisplay;
    if (totalIdealWidth > size.x) {
      // Not enough horizontal space; fit keys by width and adjust height to
      // preserve aspect ratio.
      keyWidthDisplay = size.x / _numKeys;
      keyHeightDisplay = keyWidthDisplay / keyRatio;
    } else {
      // Use the full vertical space and derive width from it.
      keyWidthDisplay = idealKeyWidth;
      keyHeightDisplay = availableHeight;
    }
    // Horizontal offset to center the keys when there is extra space.
    final double startX = (size.x - keyWidthDisplay * _numKeys) / 2;
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
        ..position = Vector2(startX + i * keyWidthDisplay, yPos)
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
      // Use ParticleSystemComponent instead of the deprecated ParticleComponent.
      // ParticleSystemComponent wraps a Particle and handles its lifecycle
      // automatically. AcceleratedParticle provides simple physics with
      // acceleration and speed; CircleParticle renders a simple circle. A
      // random horizontal spawn position makes the burst appear across the
      // width of the key.
      final particle = ParticleSystemComponent(
        particle: AcceleratedParticle(
          acceleration: Vector2(0, 50),
          speed: velocity,
          position: Vector2(_random.nextDouble() * size.x, 0),
          child: CircleParticle(
            radius: 3 + _random.nextDouble() * 2,
            paint: Paint()..color = Colors.white.withOpacity(0.8),
          ),
          lifespan: 1.0,
        ),
      )
        ..priority = 10;
      add(particle);
    }
  }
}