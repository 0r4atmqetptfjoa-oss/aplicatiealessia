import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart' hide Image;

import '../services/audio_engine_service.dart';
import '../services/gamification_bloc.dart';

/// A mini game representing four gummy drums.
///
/// Each drum pops like a bubble when tapped, plays a drum sound and
/// awards points.  Bubble particles rise from the drum after each hit.
class DrumsGame extends FlameGame {
  DrumsGame({required this.audioService, required this.gamificationBloc});

  final AudioEngineService audioService;
  final GamificationBloc gamificationBloc;

  static const List<String> _assetNames = [
    'instruments/drums/drum_red.png',
    'instruments/drums/drum_yellow.png',
    'instruments/drums/drum_green.png',
    'instruments/drums/drum_blue.png',
  ];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await images.loadAll(_assetNames);
    final int count = _assetNames.length;
    final double drumSize = size.y * 0.6;
    final double spacing = (size.x - drumSize * count) / (count + 1);
    double x = spacing + drumSize / 2;
    for (int i = 0; i < count; i++) {
      final sprite = await loadSprite(_assetNames[i]);
      final drum = _DrumComponent(
        index: i,
        sprite: sprite,
        size: Vector2.all(drumSize),
        onPressed: () => audioService.playDrum(i),
        onScored: () => gamificationBloc.addPoints(1),
      )
        ..anchor = Anchor.center
        ..position = Vector2(x, size.y / 2);
      add(drum);
      x += drumSize + spacing;
    }
  }
}

/// Internal component representing a single drum.
class _DrumComponent extends SpriteComponent with TapCallbacks {
  _DrumComponent({
    required this.index,
    required Sprite sprite,
    required Vector2 size,
    required this.onPressed,
    required this.onScored,
  }) : super(sprite: sprite, size: size);

  final int index;
  final VoidCallback onPressed;
  final VoidCallback onScored;
  bool _pressed = false;

  @override
  void onTapDown(TapDownEvent event) {
    _pressed = true;
    onPressed();
    // Squash slightly
    add(
      ScaleEffect.to(
        Vector2(0.9, 0.9),
        EffectController(duration: 0.05, curve: Curves.easeOut),
      ),
    );
    _spawnBubbles(parent as FlameGame);
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (_pressed) {
      _pressed = false;
      add(
        ScaleEffect.to(
          Vector2(1.1, 1.1),
          EffectController(duration: 0.1, reverseDuration: 0.1, curve: Curves.easeOutBack),
          onComplete: () {
            scale = Vector2.all(1.0);
            onScored();
          },
        ),
      );
    }
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    _pressed = false;
    add(
      ScaleEffect.to(
        Vector2(1.0, 1.0),
        EffectController(duration: 0.05, curve: Curves.easeOut),
      ),
    );
  }

  /// Emit rising bubble particles from the drum's centre.
  void _spawnBubbles(FlameGame game) {
    final Vector2 centre = absolutePosition + size / 2;
    game.add(
      ParticleSystemComponent(
        position: centre,
        particle: Particle.generate(
          count: 8,
          lifespan: 0.8,
          generator: (i) {
            final double angle = math.pi / 2 + (math.Random().nextDouble() - 0.5) * 0.5;
            final double speed = 40 + math.Random().nextDouble() * 40;
            final Vector2 velocity = Vector2(math.cos(angle), math.sin(angle)) * speed;
            final Color color = _colorForIndex(index).withOpacity(0.7);
            return AcceleratedParticle(
              speed: velocity,
              acceleration: Vector2(0, -speed * 0.5),
              child: CircleParticle(
                radius: 4 + math.Random().nextDouble() * 2,
                paint: Paint()..color = color,
              ),
            );
          },
        ),
      ),
    );
  }

  Color _colorForIndex(int i) {
    switch (i) {
      case 0:
        return Colors.redAccent;
      case 1:
        return Colors.amberAccent;
      case 2:
        return Colors.greenAccent;
      case 3:
      default:
        return Colors.blueAccent;
    }
  }
}