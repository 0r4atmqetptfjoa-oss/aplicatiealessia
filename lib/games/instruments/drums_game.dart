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
  static const int _numDrums = 4;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final image = await images.load('drums.png');
    final segmentWidth = image.width / _numDrums;
    final segmentHeight = image.height.toDouble();

    final double drumSize = min(size.x / _numDrums * 0.8, size.y * 0.6);
    final double yPos = (size.y - drumSize) / 2;

    for (int i = 0; i < _numDrums; i++) {
      final sprite = Sprite(
        image,
        srcPosition: Vector2(segmentWidth * i, 0),
        srcSize: Vector2(segmentWidth, segmentHeight),
      );
      final drum = _DrumPad(
        sprite: sprite,
        color: _colors[i % _colors.length],
        index: i,
        onPlayDrum: (index) {
          // TODO: Hook up audio engine for drum sound.
        },
      );
      drum
        ..size = Vector2.all(drumSize)
        ..position = Vector2((i + 0.5) * (size.x / _numDrums) - drumSize / 2, yPos)
        ..anchor = Anchor.topLeft;
      add(drum);
    }
  }

  static final List<Color> _colors = [Colors.red, Colors.yellow, Colors.green, Colors.blue];
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
    const int count = 12;
    for (int i = 0; i < count; i++) {
      final velocity = Vector2((_random.nextDouble() - 0.5) * 80, -_random.nextDouble() * 120 - 40);
      // Use ParticleSystemComponent instead of ParticleComponent. The
      // AcceleratedParticle provides a physics-based trajectory for
      // each bubble, while CircleParticle draws the bubble itself. We
      // randomize the horizontal spawn position along the top edge of
      // the drum pad.
      final particle = ParticleSystemComponent(
        particle: AcceleratedParticle(
          acceleration: Vector2(0, 60),
          speed: velocity,
          position: Vector2(_random.nextDouble() * size.x, 0),
          child: CircleParticle(
            radius: 4 + _random.nextDouble() * 2,
            paint: Paint()..color = color.withOpacity(0.7),
          ),
          lifespan: 1.2,
        ),
      )
        ..priority = 10;
      add(particle);
    }
  }
}