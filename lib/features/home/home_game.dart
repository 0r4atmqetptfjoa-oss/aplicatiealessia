import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_router.dart';

class HomeGame extends FlameGame with HasTappables, HasDraggables, HasCollisionDetection {
  late TextComponent title;
  final double _buttonSize = 128;

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'placeholders/placeholder_landscape.png',
      'placeholders/placeholder_square.png',
    ]);

    final parallax = await loadParallaxComponent(
      [
        // TODO (Răzvan): Înlocuiește placeholder-ele cu resursele finale din /final:
        // ParallaxImageData('parallax_back.png'),
        // ParallaxImageData('parallax_middle.png'),
        // ParallaxImageData('parallax_front.png'),
        ParallaxImageData('placeholders/placeholder_landscape.png'),
        ParallaxImageData('placeholders/placeholder_landscape.png'),
        ParallaxImageData('placeholders/placeholder_landscape.png'),
      ],
      baseVelocity: Vector2(10, 0),
      velocityMultiplierDelta: Vector2(1.4, 1),
    );
    add(parallax);

    title = TextComponent(
      text: 'Alesia',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 64,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          shadows: [Shadow(offset: Offset(0, 2), blurRadius: 8)],
        ),
      ),
      anchor: Anchor.topCenter,
      position: Vector2(size.x / 2, 48),
    );
    add(title);

    title.add(
      SequenceEffect([
        MoveByEffect(Vector2(0, 10), EffectController(duration: 1.6, curve: Curves.easeInOut)),
        MoveByEffect(Vector2(0, -10), EffectController(duration: 1.6, curve: Curves.easeInOut)),
        ScaleEffect.to(Vector2(1.02, 1.02), EffectController(duration: 0.8, curve: Curves.easeInOut)),
        ScaleEffect.to(Vector2(1.0, 1.0), EffectController(duration: 0.8, curve: Curves.easeInOut)),
      ], infinite: true),
    );

    final buttons = <MenuButton>[
      // TODO (Răzvan): Înlocuiește fiecare placeholder cu resursa finală:
      MenuButton(assetPath: 'placeholders/placeholder_square.png', route: '/instrumente'), // Final: 'harp.png'
      MenuButton(assetPath: 'placeholders/placeholder_square.png', route: '/canciones'),   // Final: 'music_box.png'
      MenuButton(assetPath: 'placeholders/placeholder_square.png', route: '/povesti'),     // Final: 'story_book.png'
      MenuButton(assetPath: 'placeholders/placeholder_square.png', route: '/jocuri'),      // Final: 'play_cube.png'
      MenuButton(assetPath: 'placeholders/placeholder_square.png', route: '/sunete'),      // Final: 'seashell.png'
    ];

    final totalWidth = buttons.length * _buttonSize + (buttons.length - 1) * 24;
    var startX = (size.x - totalWidth) / 2;
    final y = size.y * 0.6;
    for (final b in buttons) {
      b
        ..size = Vector2(_buttonSize, _buttonSize)
        ..position = Vector2(startX, y)
        ..anchor = Anchor.center;
      add(b);
      startX += _buttonSize + 24;
    }
  }
}

class MenuButton extends SpriteComponent with TapCallbacks {
  MenuButton({required this.assetPath, required this.route});
  final String assetPath;
  final String route;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(assetPath);
  }

  @override
  void onTapDown(TapDownEvent event) {
    add(ScaleEffect.to(Vector2.all(0.9), EffectController(duration: 0.08)));
    add(RotateEffect.to(math.pi / 36, EffectController(duration: 0.08))); // ~5°
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    add(ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.10)));
    add(RotateEffect.to(0, EffectController(duration: 0.10)));
    final ctx = rootNavigatorKey.currentContext;
    if (ctx != null) {
      GoRouter.of(ctx).go(route);
    }
    super.onTapUp(event);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    add(ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.10)));
    add(RotateEffect.to(0, EffectController(duration: 0.10)));
    super.onTapCancel(event);
  }
}
