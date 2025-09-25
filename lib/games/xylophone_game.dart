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

/// A mini game representing a xylophone made of pastel wooden bars.
///
/// Each bar glows and releases magical dust when tapped.  Bars are laid
/// out horizontally and sized relative to the screen.
class XylophoneGame extends FlameGame {
  XylophoneGame({required this.audioService, required this.gamificationBloc});

  final AudioEngineService audioService;
  final GamificationBloc gamificationBloc;

  static const List<String> _assetNames = [
    'instruments/xylophone/bar_pink.png',
    'instruments/xylophone/bar_blue.png',
    'instruments/xylophone/bar_green.png',
    'instruments/xylophone/bar_violet.png',
  ];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await images.loadAll(_assetNames);
    final int count = _assetNames.length;
    final double barWidth = size.x / count;
    final double barHeight = size.y * 0.7;
    double x = barWidth / 2;
    for (int i = 0; i < count; i++) {
      final sprite = await loadSprite(_assetNames[i]);
      final bar = _XylophoneBar(
        index: i,
        sprite: sprite,
        size: Vector2(barWidth * 0.85, barHeight),
        onPressed: () => audioService.playXylophone(i),
        onScored: () => gamificationBloc.addPoints(1),
      )
        ..anchor = Anchor.center
        ..position = Vector2(x, size.y / 2);
      add(bar);
      x += barWidth;
    }
  }
}

/// Internal component representing a single xylophone bar.
class _XylophoneBar extends SpriteComponent with TapCallbacks {
  _XylophoneBar({
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
    add(
      ScaleEffect.to(
        Vector2(0.9, 0.9),
        EffectController(duration: 0.05, curve: Curves.easeOut),
      ),
    );
    _spawnMagicDust(parent as FlameGame);
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (_pressed) {
      _pressed = false;
      add(
        ScaleEffect.to(
          Vector2(1.1, 1.1),
          EffectController(
            duration: 0.12,
            reverseDuration: 0.12,
            curve: Curves.easeOutBack,
          ),
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

  /// Emit magic dust particles with a gentle upward drift.
  void _spawnMagicDust(FlameGame game) {
    final Vector2 centre = absolutePosition + size / 2;
    final Color colour = _colorForIndex(index);
    final rand = math.Random();
    final particles = List<Particle>.generate(15, (i) {
      final double angle = -math.pi / 2 + (rand.nextDouble() - 0.5) * math.pi / 4;
      final double speed = 30 + rand.nextDouble() * 30;
      final Vector2 velocity = Vector2(math.cos(angle), math.sin(angle)) * speed;
      final Vector2 acceleration = Vector2(0, -speed * 0.3);
      final double radius = 2 + rand.nextDouble() * 3;
      return CircleParticle(
        radius: radius,
        paint: Paint()..color = colour.withOpacity(0.9),
        lifespan: 0.8,
      ).accelerated(
        acceleration: acceleration,
        velocity: velocity,
      );
    });
    final particle = ComposedParticle(children: particles, lifespan: 0.8);
    game.add(
      ParticleSystemComponent(
        position: centre,
        particle: particle,
      ),
    );
  }

  Color _colorForIndex(int i) {
    switch (i) {
      case 0:
        return Colors.pinkAccent;
      case 1:
        return Colors.lightBlueAccent;
      case 2:
        return Colors.lightGreenAccent;
      case 3:
      default:
        return Colors.purpleAccent;
    }
  }
}