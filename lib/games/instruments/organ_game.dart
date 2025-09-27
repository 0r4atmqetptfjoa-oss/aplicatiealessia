import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
// Import Flame particles library to access AcceleratedParticle and
// CircleParticle classes. This is required for the new particle API.
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

/// A game representing an underwater pipe organ. Keys are iridescent shells
/// cropped from a sprite and emit bubbles when pressed. Integrate audio via
/// [onPlayKey].
class OrganGame extends FlameGame {
  /// File names for the individual organ key sprites. Each entry corresponds
  /// to an iridescent shell key in pastel aquatic colours. The order in
  /// this list determines the visual arrangement from left to right.
  static const List<String> _keyFiles = [
    'organ/scoica_1.png',
    'organ/scoica_2.png',
    'organ/scoica_3.png',
    'organ/scoica_4.png',
    'organ/scoica_5.png',
  ];

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 1. Add a full‑screen background for the organ scene.
    final bgSprite = await loadSprite('backgrounds/background_organ.png');
    add(
      SpriteComponent(sprite: bgSprite)
        ..size = size
        ..position = Vector2.zero(),
    );

    // 2. Load each individual organ key sprite. Use the first key to
    // determine the intrinsic aspect ratio shared by all keys.
    final keySprites = <Sprite>[];
    for (final file in _keyFiles) {
      keySprites.add(await loadSprite(file));
    }

    // Compute display size for each key while preserving aspect ratio. Use
    // 70% of the vertical space and derive the width from the sprite ratio.
    // Introduce spacing between keys and scale down if they exceed the
    // horizontal space available.
    const double spacing = 14.0;
    final double availableHeight = size.y * 0.7;
    final double intrinsicRatio =
        keySprites.first.srcSize.x / keySprites.first.srcSize.y;
    double keyHeightDisplay = availableHeight;
    double keyWidthDisplay = keyHeightDisplay * intrinsicRatio;
    final int numKeys = keySprites.length;
    double totalWidth = keyWidthDisplay * numKeys + (numKeys - 1) * spacing;
    if (totalWidth > size.x) {
      keyWidthDisplay = (size.x - (numKeys - 1) * spacing) / numKeys;
      keyHeightDisplay = keyWidthDisplay / intrinsicRatio;
      totalWidth = keyWidthDisplay * numKeys + (numKeys - 1) * spacing;
    }
    final double startX = (size.x - totalWidth) / 2;
    final double yPos = (size.y - keyHeightDisplay) / 2;

    // Water palette used to tint the bubble particles for each key.
    const List<Color> palette = [
      Color(0xFFB2EBF2), // light cyan
      Color(0xFFB3E5FC), // light blue
      Color(0xFFC5CAE9), // light periwinkle
      Color(0xFFD1C4E9), // light lavender
      Color(0xFFE1BEE7), // light purple
    ];

    for (int i = 0; i < numKeys; i++) {
      final key = _OrganKey(
        sprite: keySprites[i],
        index: i,
        color: palette[i % palette.length],
        onPlayKey: (index) {
          // TODO: Hook into audio service to play organ notes.
        },
      );
      key
        ..size = Vector2(keyWidthDisplay, keyHeightDisplay)
        ..position = Vector2(startX + i * (keyWidthDisplay + spacing), yPos)
        ..anchor = Anchor.topLeft;
      add(key);
    }
  }

  // The palette of watery pastel colours used for bubble particles is
  // defined in-line above. No need for a static field here.
}

class _OrganKey extends SpriteComponent with TapCallbacks {
  _OrganKey({required super.sprite, required this.index, required this.color, required this.onPlayKey});

  final int index;
  final Color color;
  final void Function(int index) onPlayKey;
  final Random _random = Random();

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    onPlayKey(index);
    add(ScaleEffect.to(
      Vector2(0.92, 0.92),
      EffectController(duration: 0.05, reverseDuration: 0.05),
    ));
    _spawnBubbles();
  }

  void _spawnBubbles() {
    // Release a stream of iridescent bubbles. We vary the size and
    // colours across a watery palette and let them rise slowly before
    // drifting down, like bubbles underwater. A gentle acceleration
    // simulates buoyancy and water resistance.
    const List<Color> palette = [
      Color(0xFFB2EBF2), // light cyan
      Color(0xFFB3E5FC), // light blue
      Color(0xFFC5CAE9), // light periwinkle
      Color(0xFFD1C4E9), // light lavender
      Color(0xFFE1BEE7), // light purple
    ];
    const int count = 10;
    for (int i = 0; i < count; i++) {
      final velocity = Vector2(
        (_random.nextDouble() - 0.5) * 30,
        -_random.nextDouble() * 80 - 30,
      );
      final particle = ParticleSystemComponent(
        particle: AcceleratedParticle(
          acceleration: Vector2(0, 40),
          speed: velocity,
          position: Vector2(_random.nextDouble() * size.x, 0),
          child: CircleParticle(
            radius: 4 + _random.nextDouble() * 4,
            paint: Paint()
              ..color = palette[_random.nextInt(palette.length)].withOpacity(0.7),
          ),
          lifespan: 1.6,
        ),
      )
        ..priority = 10;
      add(particle);
    }
  }
}