import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
// Import Flame particles to access AcceleratedParticle, CircleParticle and
// other particle classes. Required when using ParticleSystemComponent.
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

/// A game that displays four gummy drum pads. Each pad can be tapped to
/// produce a squash effect and colorful bubble particles. Audio and
/// gamification events can be integrated via the [onPlayDrum] callback.
class DrumsGame extends FlameGame {
  /// File names for the individual drum pad sprites. The order of this list
  /// corresponds to the visual arrangement from left to right on the screen.
  static const List<String> _drumFiles = [
    'drums/toba_rosie.png',
    'drums/toba_galbena.png',
    'drums/toba_verde.png',
    'drums/toba_albastra.png',
  ];

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 1. Add a full‑screen background for the drums scene.
    final bgSprite = await loadSprite('backgrounds/background_drums.png');
    add(
      SpriteComponent(sprite: bgSprite)
        ..size = size
        ..position = Vector2.zero(),
    );

    // 2. Load each drum pad sprite individually. All pads share the same
    // intrinsic aspect ratio (their width to height) so we can use the
    // first sprite to determine layout ratios.
    final drumSprites = <Sprite>[];
    for (final file in _drumFiles) {
      drumSprites.add(await loadSprite(file));
    }

    // Determine display sizes for each drum pad while maintaining aspect ratio.
    // Allocate 60% of the vertical space to the pads and derive the width
    // based on the sprite ratio. Apply a small spacing between pads. If the
    // total width exceeds the available horizontal space, scale down to fit.
    const double spacing = 16.0;
    final double availableHeight = size.y * 0.6;
    final double intrinsicRatio =
        drumSprites.first.srcSize.x / drumSprites.first.srcSize.y;
    double drumHeightDisplay = availableHeight;
    double drumWidthDisplay = drumHeightDisplay * intrinsicRatio;
    final int numDrums = drumSprites.length;
    double totalWidth = drumWidthDisplay * numDrums + (numDrums - 1) * spacing;
    if (totalWidth > size.x) {
      drumWidthDisplay = (size.x - (numDrums - 1) * spacing) / numDrums;
      drumHeightDisplay = drumWidthDisplay / intrinsicRatio;
      totalWidth = drumWidthDisplay * numDrums + (numDrums - 1) * spacing;
    }
    final double startX = (size.x - totalWidth) / 2;
    final double yPos = (size.y - drumHeightDisplay) / 2;

    // Use a palette of primary colours to give each pad its own particle tint.
    const List<Color> palette = [
      Colors.red,
      Colors.yellow,
      Colors.green,
      Colors.blue,
    ];

    for (int i = 0; i < numDrums; i++) {
      final drum = _DrumPad(
        sprite: drumSprites[i],
        color: palette[i % palette.length],
        index: i,
        onPlayDrum: (index) {
          // TODO: Hook up audio engine for drum sound.
        },
      );
      drum
        ..size = Vector2(drumWidthDisplay, drumHeightDisplay)
        ..position = Vector2(startX + i * (drumWidthDisplay + spacing), yPos)
        ..anchor = Anchor.topLeft;
      add(drum);
    }
  }
}

class _DrumPad extends SpriteComponent with TapCallbacks {
  _DrumPad({required super.sprite, required this.color, required this.index, required this.onPlayDrum});

  final Color color;
  final int index;
  final void Function(int index) onPlayDrum;
  final Random _random = Random();

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    onPlayDrum(index);
    add(ScaleEffect.to(
      Vector2(0.85, 0.85),
      EffectController(duration: 0.05, reverseDuration: 0.05),
    ));
    _spawnBubbles();
  }

  void _spawnBubbles() {
    // Create an energetic burst of jelly pieces. Each particle chooses a
    // random colour from the primary palette and a random direction.
    // Particles start with an upward velocity and then fall back down
    // under a gentle acceleration to simulate a playful splash.
    const List<Color> palette = [
      Colors.red,
      Colors.yellow,
      Colors.green,
      Colors.blue,
    ];
    const int count = 10;
    for (int i = 0; i < count; i++) {
      final velocity = Vector2(
        (_random.nextDouble() - 0.5) * 100,
        -_random.nextDouble() * 150 - 50,
      );
      final particle = ParticleSystemComponent(
        particle: AcceleratedParticle(
          acceleration: Vector2(0, 80),
          speed: velocity,
          position: Vector2(_random.nextDouble() * size.x, 0),
          child: CircleParticle(
            radius: 5 + _random.nextDouble() * 4,
            paint: Paint()
              ..color = palette[_random.nextInt(palette.length)].withOpacity(0.8),
          ),
          lifespan: 1.4,
        ),
      )
        ..priority = 10;
      add(particle);
    }
  }
}