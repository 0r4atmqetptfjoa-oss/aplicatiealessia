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
  /// The file names of the individual piano key sprites.
  static const List<String> _keyFiles = [
    'piano/clapa_rosie.png',
    'piano/clapa_portocalie.png',
    'piano/clapa_galbena.png',
    'piano/clapa_verde.png',
    'piano/clapa_albastra.png',
    'piano/clapa_indigo.png',
    'piano/clapa_violeta.png',
  ];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // 1. Add a full‑screen background for the piano scene.
    final bgSprite = await loadSprite('backgrounds/background_piano.png');
    add(
      SpriteComponent(sprite: bgSprite)
        ..size = size
        ..position = Vector2.zero(),
    );

    // 2. Load each individual piano key sprite.
    final keySprites = <Sprite>[];
    for (final file in _keyFiles) {
      keySprites.add(await loadSprite(file));
    }

    // Determine display size for each key while preserving aspect ratio. Use
    // 80% of the vertical space for keys.
    final double availableHeight = size.y * 0.8;
    // All keys share the same intrinsic aspect ratio, use the first key as
    // reference.
    final double intrinsicRatio =
        keySprites.first.srcSize.x / keySprites.first.srcSize.y;
    double keyHeightDisplay = availableHeight;
    double keyWidthDisplay = keyHeightDisplay * intrinsicRatio;
    final int numKeys = keySprites.length;
    const double spacing = 10.0;
    // If the total width exceeds the available horizontal space, scale down.
    double totalWidth = keyWidthDisplay * numKeys + (numKeys - 1) * spacing;
    if (totalWidth > size.x) {
      keyWidthDisplay = (size.x - (numKeys - 1) * spacing) / numKeys;
      keyHeightDisplay = keyWidthDisplay / intrinsicRatio;
      totalWidth = keyWidthDisplay * numKeys + (numKeys - 1) * spacing;
    }
    final double startX = (size.x - totalWidth) / 2;
    final double yPos = (size.y - keyHeightDisplay) / 2;

    for (int i = 0; i < numKeys; i++) {
      final key = _PianoKey(
        sprite: keySprites[i],
        noteIndex: i,
        onPlayNote: (index) {
          // TODO: Connect to AudioEngineService to play the corresponding note.
        },
      );
      key
        ..size = Vector2(keyWidthDisplay, keyHeightDisplay)
        ..position = Vector2(startX + i * (keyWidthDisplay + spacing), yPos)
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
    // Generate a burst of shimmering notes/stars. We choose a golden color
    // reminiscent of sparkling music and vary the velocities so that
    // particles shoot upward and then fall under gravity. Using a
    // ParticleSystemComponent ensures each particle cleans itself up when
    // expired.
    const int count = 12;
    for (int i = 0; i < count; i++) {
      final velocity = Vector2(
        (_random.nextDouble() - 0.5) * 60,
        -_random.nextDouble() * 90 - 30,
      );
      final particle = ParticleSystemComponent(
        particle: AcceleratedParticle(
          acceleration: Vector2(0, 60),
          speed: velocity,
          position: Vector2(_random.nextDouble() * size.x, 0),
          child: CircleParticle(
            radius: 3 + _random.nextDouble() * 3,
            paint: Paint()..color = const Color(0xFFFFD700).withOpacity(0.85),
          ),
          lifespan: 1.2,
        ),
      )
        ..priority = 10;
      add(particle);
    }
  }
}