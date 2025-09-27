import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
// Include the Flame particles library to access particle classes such as
// AcceleratedParticle and CircleParticle. Without this import, these
// classes are not available when compiling with the latest Flame version.
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

/// A game presenting a magical xylophone. Bars glow softly and emit
/// sparkling dust when played. Each bar is divided from a single sprite and
/// animated on tap. Hook into [onPlayBar] for audio playback.
class XylophoneGame extends FlameGame {
  static const int _numBars = 8;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final image = await images.load('xylophone.png');
    final barWidth = image.width / _numBars;
    final barHeight = image.height.toDouble();
    // Compute display sizes while maintaining aspect ratio. We allocate 75% of
    // vertical space for the bars and derive the ideal width based on the
    // sprite ratio. If the total width exceeds the available horizontal
    // space, scale down accordingly.
    final double availableHeight = size.y * 0.75;
    final double ratio = barWidth / barHeight;
    final double idealWidth = availableHeight * ratio;
    final double totalIdealWidth = idealWidth * _numBars;
    late double barWidthDisplay;
    late double barHeightDisplay;
    if (totalIdealWidth > size.x) {
      barWidthDisplay = size.x / _numBars;
      barHeightDisplay = barWidthDisplay / ratio;
    } else {
      barWidthDisplay = idealWidth;
      barHeightDisplay = availableHeight;
    }
    final double startX = (size.x - barWidthDisplay * _numBars) / 2;
    final double yPos = (size.y - barHeightDisplay) / 2;

    for (int i = 0; i < _numBars; i++) {
      final sprite = Sprite(
        image,
        srcPosition: Vector2(barWidth * i, 0),
        srcSize: Vector2(barWidth, barHeight),
      );
      final bar = _XyloBar(
        sprite: sprite,
        index: i,
        color: _pastelColors[i % _pastelColors.length],
        onPlayBar: (index) {
          // TODO: Integrate audio service for xylophone notes.
        },
      );
      bar
        ..size = Vector2(barWidthDisplay, barHeightDisplay)
        ..position = Vector2(startX + i * barWidthDisplay, yPos)
        ..anchor = Anchor.topLeft;
      add(bar);
    }
  }

  static final List<Color> _pastelColors = [
    const Color(0xFFFFC1CC), // pastel pink
    const Color(0xFFFFE4B5), // pastel orange
    const Color(0xFFFFF9C4), // pastel yellow
    const Color(0xFFC8E6C9), // pastel green
    const Color(0xFFB3E5FC), // pastel blue
    const Color(0xFFD1C4E9), // pastel purple
    const Color(0xFFFFCC80), // pastel peach
    const Color(0xFFCFD8DC), // pastel grey
  ];
}

class _XyloBar extends SpriteComponent with TapCallbacks {
  _XyloBar({required super.sprite, required this.index, required this.color, required this.onPlayBar});

  final int index;
  final Color color;
  final void Function(int index) onPlayBar;
  final Random _random = Random();

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    onPlayBar(index);
    add(ScaleEffect.to(
      Vector2(0.95, 0.9),
      EffectController(duration: 0.05, reverseDuration: 0.05),
    ));
    _spawnDust();
  }

  void _spawnDust() {
    const int count = 15;
    for (int i = 0; i < count; i++) {
      final velocity = Vector2((_random.nextDouble() - 0.5) * 40, -_random.nextDouble() * 100 - 30);
      // Create the particle using ParticleSystemComponent for Flame 1.23+.
      // AcceleratedParticle adds velocity and acceleration physics and
      // CircleParticle draws the glowing dust. We randomize the spawn
      // position along the top of the bar for a dispersed effect.
      final particle = ParticleSystemComponent(
        particle: AcceleratedParticle(
          acceleration: Vector2(0, 70),
          speed: velocity,
          position: Vector2(_random.nextDouble() * size.x, 0),
          child: CircleParticle(
            radius: 2 + _random.nextDouble() * 2,
            paint: Paint()..color = color.withOpacity(0.8),
          ),
          lifespan: 1.2,
        ),
      )
        ..priority = 10;
      add(particle);
    }
  }
}