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
  static const int _numKeys = 5;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final image = await images.load('organ.png');
    final keyWidth = image.width / _numKeys;
    final keyHeight = image.height.toDouble();

    final double keyHeightDisplay = size.y * 0.7;
    final double keyWidthDisplay = size.x / _numKeys;
    final double yPos = (size.y - keyHeightDisplay) / 2;

    for (int i = 0; i < _numKeys; i++) {
      final sprite = Sprite(
        image,
        srcPosition: Vector2(keyWidth * i, 0),
        srcSize: Vector2(keyWidth, keyHeight),
      );
      final key = _OrganKey(
        sprite: sprite,
        index: i,
        color: _waterColors[i % _waterColors.length],
        onPlayKey: (index) {
          // TODO: Hook into audio service to play organ notes.
        },
      );
      key
        ..size = Vector2(keyWidthDisplay, keyHeightDisplay)
        ..position = Vector2(i * keyWidthDisplay, yPos)
        ..anchor = Anchor.topLeft;
      add(key);
    }
  }

  static final List<Color> _waterColors = [
    const Color(0xFFB2EBF2), // light cyan
    const Color(0xFFB3E5FC), // light blue
    const Color(0xFFC5CAE9), // light periwinkle
    const Color(0xFFD1C4E9), // light lavender
    const Color(0xFFE1BEE7), // light purple
  ];
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
    const int count = 8;
    for (int i = 0; i < count; i++) {
      final velocity = Vector2((_random.nextDouble() - 0.5) * 20, -_random.nextDouble() * 60 - 20);
      // Use ParticleSystemComponent to wrap our particle effect.
      // Each bubble uses an AcceleratedParticle with a downward
      // acceleration simulating water resistance. CircleParticle
      // draws the bubble itself. We randomize the horizontal position
      // for variation.
      final particle = ParticleSystemComponent(
        particle: AcceleratedParticle(
          acceleration: Vector2(0, 30),
          speed: velocity,
          position: Vector2(_random.nextDouble() * size.x, 0),
          child: CircleParticle(
            radius: 5 + _random.nextDouble() * 3,
            paint: Paint()..color = color.withOpacity(0.6),
          ),
          lifespan: 1.5,
        ),
      )
        ..priority = 10;
      add(particle);
    }
  }
}