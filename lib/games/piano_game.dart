import 'dart:ui';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart' hide Image;

import '../services/audio_engine_service.dart';
import '../services/gamification_bloc.dart';

/// A mini game that renders a row of seven colourful piano keys.
///
/// Each key can be tapped to play a note, produce a sparkle particle
/// effect and increment the score via the [GamificationBloc].  The
/// keys are sized dynamically based on the game viewport to fill the
/// available space in landscape orientation.
class PianoGame extends FlameGame {
  PianoGame({required this.audioService, required this.gamificationBloc});

  final AudioEngineService audioService;
  final GamificationBloc gamificationBloc;

  // List of asset names for each piano key.
  static const List<String> _assetNames = [
    'instruments/piano/key_red.png',
    'instruments/piano/key_orange.png',
    'instruments/piano/key_yellow.png',
    'instruments/piano/key_green.png',
    'instruments/piano/key_blue.png',
    'instruments/piano/key_indigo.png',
    'instruments/piano/key_violet.png',
  ];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Preload all piano key images.
    await images.loadAll(_assetNames);

    final int keyCount = _assetNames.length;
    final double keyWidth = size.x / keyCount;
    final double keyHeight = size.y * 0.8;
    double x = keyWidth / 2;
    for (int i = 0; i < keyCount; i++) {
      final sprite = await loadSprite(_assetNames[i]);
      final key = _PianoKeyComponent(
        index: i,
        sprite: sprite,
        size: Vector2(keyWidth * 0.9, keyHeight),
        onPressed: () => audioService.playPianoKey(i),
        onScored: () => gamificationBloc.addPoints(1),
      )
        ..anchor = Anchor.center
        ..position = Vector2(x, size.y / 2);
      add(key);
      x += keyWidth;
    }
  }
}

/// Internal component representing a single piano key.
class _PianoKeyComponent extends SpriteComponent with TapCallbacks {
  _PianoKeyComponent({
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
    // Squash effect when pressed.
    add(
      ScaleEffect.to(
        Vector2(0.95, 0.95),
        EffectController(duration: 0.05, curve: Curves.easeOut),
      ),
    );
    // Spawn sparkle particles at the key centre.
    _spawnSparkle(parent as FlameGame);
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (_pressed) {
      _pressed = false;
      // Stretch and bounce back.
      add(
        ScaleEffect.to(
          Vector2(1.05, 1.05),
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

  /// Emit a burst of small sparkle particles above the key.
  void _spawnSparkle(FlameGame game) {
    final Vector2 center = absolutePosition + size / 2;
    game.add(
      ParticleSystemComponent(
        position: center,
        particle: Particle.generate(
          count: 12,
          lifespan: 0.5,
          generator: (i) {
            final double angle = math.pi * 2 * (i / 12);
            final Vector2 velocity = Vector2(math.cos(angle), math.sin(angle)) * 60;
            final Color color = _colorForIndex(index);
            return AcceleratedParticle(
              speed: velocity,
              acceleration: -velocity * 2,
              child: CircleParticle(
                radius: 2,
                paint: Paint()..color = color.withOpacity(0.8),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Returns a colour associated with the key index to tint sparkle particles.
  Color _colorForIndex(int i) {
    switch (i) {
      case 0:
        return Colors.redAccent;
      case 1:
        return Colors.deepOrangeAccent;
      case 2:
        return Colors.amber;
      case 3:
        return Colors.greenAccent;
      case 4:
        return Colors.blueAccent;
      case 5:
        return Colors.indigo;
      case 6:
      default:
        return Colors.purpleAccent;
    }
  }
}