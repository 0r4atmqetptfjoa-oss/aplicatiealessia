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
  /// File names for the individual xylophone bar sprites. The order of this
  /// list corresponds to the arrangement of bars from left to right. Each
  /// file name refers to a pastel‑coloured wooden bar.
  static const List<String> _barFiles = [
    'xylophone/bara_1.png',
    'xylophone/bara_2.png',
    'xylophone/bara_3.png',
    'xylophone/bara_4.png',
    'xylophone/bara_5.png',
    'xylophone/bara_6.png',
    'xylophone/bara_7.png',
    'xylophone/bara_8.png',
  ];

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 1. Add a full‑screen background for the xylophone scene. We reuse the
    // warm studio background which works well for wooden instruments.
    final bgSprite = await loadSprite('backgrounds/background_piano.png');
    add(
      SpriteComponent(sprite: bgSprite)
        ..size = size
        ..position = Vector2.zero(),
    );

    // 2. Load individual bar sprites. Their intrinsic aspect ratios are
    // assumed identical, so we use the first bar for ratio calculations.
    final barSprites = <Sprite>[];
    for (final file in _barFiles) {
      barSprites.add(await loadSprite(file));
    }

    // Determine display sizes while maintaining aspect ratio. Use 75% of the
    // vertical space for the bars. Introduce a small spacing between bars.
    const double spacing = 12.0;
    final double availableHeight = size.y * 0.75;
    final double intrinsicRatio =
        barSprites.first.srcSize.x / barSprites.first.srcSize.y;
    double barHeightDisplay = availableHeight;
    double barWidthDisplay = barHeightDisplay * intrinsicRatio;
    final int numBars = barSprites.length;
    double totalWidth = barWidthDisplay * numBars + (numBars - 1) * spacing;
    if (totalWidth > size.x) {
      barWidthDisplay = (size.x - (numBars - 1) * spacing) / numBars;
      barHeightDisplay = barWidthDisplay / intrinsicRatio;
      totalWidth = barWidthDisplay * numBars + (numBars - 1) * spacing;
    }
    final double startX = (size.x - totalWidth) / 2;
    final double yPos = (size.y - barHeightDisplay) / 2;

    for (int i = 0; i < numBars; i++) {
      final bar = _XyloBar(
        sprite: barSprites[i],
        index: i,
        color: _pastelColors[i % _pastelColors.length],
        onPlayBar: (index) {
          // TODO: Integrate audio service for xylophone notes.
        },
      );
      bar
        ..size = Vector2(barWidthDisplay, barHeightDisplay)
        ..position = Vector2(startX + i * (barWidthDisplay + spacing), yPos)
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
    // Emit a cloud of shimmering fairy dust. We increase the particle
    // count and reduce the radius for a fine sparkle effect. A gentle
    // acceleration makes the particles drift downward slowly, while
    // starting velocities shoot them slightly upward and sideways.
    const int count = 20;
    for (int i = 0; i < count; i++) {
      final velocity = Vector2(
        (_random.nextDouble() - 0.5) * 50,
        -_random.nextDouble() * 120 - 40,
      );
      final particle = ParticleSystemComponent(
        particle: AcceleratedParticle(
          acceleration: Vector2(0, 60),
          speed: velocity,
          position: Vector2(_random.nextDouble() * size.x, 0),
          child: CircleParticle(
            radius: 1 + _random.nextDouble() * 3,
            paint: Paint()..color = color.withOpacity(0.9),
          ),
          lifespan: 1.4,
        ),
      )
        ..priority = 10;
      add(particle);
    }
  }
}