import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart' hide Image;

import '../services/audio_engine_service.dart';
import '../services/gamification_bloc.dart';

/// A mini game representing an underwater organ made of coral pipes and
/// seashell keys.
///
/// Five seashell keys sit in front of colourful coral pipes.  When
/// tapped they emit rising bubbles, play organ sounds and increment the
/// gamification score.
class OrganGame extends FlameGame with HasTappables {
  OrganGame({required this.audioService, required this.gamificationBloc});

  final AudioEngineService audioService;
  final GamificationBloc gamificationBloc;

  static const String _backgroundAsset = 'instruments/organ/organ_corals.png';
  static const String _shellAsset = 'instruments/organ/shell.png';

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await images.loadAll([_backgroundAsset, _shellAsset]);

    // Add the coral background centred on the bottom half of the screen.
    final bgSprite = await loadSprite(_backgroundAsset);
    final bgWidth = size.x * 0.5;
    final double scaleFactor = bgWidth / bgSprite.srcSize.x;
    final bgHeight = bgSprite.srcSize.y * scaleFactor;
    final bg = SpriteComponent(
      sprite: bgSprite,
      size: Vector2(bgWidth, bgHeight),
    )
      ..anchor = Anchor.center
      ..position = Vector2(size.x / 2, size.y * 0.45);
    add(bg);

    // Load the shell sprite once; tinting will occur in components.
    final shellSprite = await loadSprite(_shellAsset);
    final int keyCount = 5;
    final double keyWidth = size.x / (keyCount + 1);
    final double keyHeight = size.y * 0.3;
    double x = keyWidth;
    for (int i = 0; i < keyCount; i++) {
      final colour = _colorForIndex(i);
      final key = _OrganKey(
        index: i,
        sprite: shellSprite,
        size: Vector2(keyWidth * 0.6, keyHeight),
        colour: colour,
        onPressed: () => audioService.playOrgan(i),
        onScored: () => gamificationBloc.addPoints(1),
      )
        ..anchor = Anchor.bottomCenter
        ..position = Vector2(x, size.y * 0.9);
      add(key);
      x += keyWidth;
    }
  }

  /// Provide different pastel colours for each shell key.
  Color _colorForIndex(int i) {
    switch (i) {
      case 0:
        return Colors.pinkAccent;
      case 1:
        return Colors.lightBlueAccent;
      case 2:
        return Colors.lightGreenAccent;
      case 3:
        return Colors.amberAccent;
      case 4:
      default:
        return Colors.purpleAccent;
    }
  }
}

/// Internal component representing a single seashell key.
class _OrganKey extends SpriteComponent with Tappable {
  _OrganKey({
    required this.index,
    required Sprite sprite,
    required Vector2 size,
    required this.colour,
    required this.onPressed,
    required this.onScored,
  }) : super(sprite: sprite, size: size);

  final int index;
  final Color colour;
  final VoidCallback onPressed;
  final VoidCallback onScored;
  bool _pressed = false;

  @override
  void render(Canvas canvas) {
    // Apply tint by drawing the sprite with a coloured paint.
    final Paint paint = Paint()
      ..colorFilter = ColorFilter.mode(colour, BlendMode.modulate);
    sprite!.render(canvas, size: size, overridePaint: paint);
  }

  @override
  bool onTapDown(TapDownEvent event) {
    _pressed = true;
    onPressed();
    add(
      ScaleEffect.to(
        Vector2(0.9, 0.9),
        EffectController(duration: 0.05, curve: Curves.easeOut),
      ),
    );
    _spawnBubbles(parent as FlameGame);
    return true;
  }

  @override
  bool onTapUp(TapUpEvent event) {
    if (_pressed) {
      _pressed = false;
      add(
        ScaleEffect.to(
          Vector2(1.1, 1.1),
          EffectController(duration: 0.12, reverseDuration: 0.12, curve: Curves.easeOutBack),
          onComplete: () {
            scale = Vector2.all(1.0);
            onScored();
          },
        ),
      );
    }
    return true;
  }

  @override
  bool onTapCancel() {
    _pressed = false;
    add(
      ScaleEffect.to(
        Vector2(1.0, 1.0),
        EffectController(duration: 0.05, curve: Curves.easeOut),
      ),
    );
    return true;
  }

  /// Emit gentle rising bubbles when the key is pressed.
  void _spawnBubbles(FlameGame game) {
    final Vector2 origin = absolutePosition + Vector2(size.x / 2, 0);
    game.add(
      ParticleSystemComponent(
        position: origin,
        particle: Particle.generate(
          count: 10,
          lifespan: 1.2,
          generator: (i) {
            final double angle = -math.pi / 2 + (math.Random().nextDouble() - 0.5) * math.pi / 6;
            final double speed = 20 + math.Random().nextDouble() * 20;
            final Vector2 velocity = Vector2(math.cos(angle), math.sin(angle)) * speed;
            final double radius = 3 + math.Random().nextDouble() * 3;
            return AcceleratedParticle(
              speed: velocity,
              acceleration: Vector2(0, -speed * 0.2),
              child: CircleParticle(
                radius: radius,
                paint: Paint()..color = colour.withOpacity(0.8),
              ),
            );
          },
        ),
      ),
    );
  }
}