import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/service_locator.dart';
import '../services/audio_engine_service.dart';

/// The main menu scene of the Alesia app.
///
/// This game draws a parallax background, a floating title and a set of
/// interactive buttons that navigate to different modules of the app.
class HomeGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load and add a parallax with three layers.  A higher base velocity
    // makes the closest layer scroll faster than the far ones.
    final parallax = await ParallaxComponent.load(
      [
        ParallaxImageData('background_back.png'),
        ParallaxImageData('background_middle.png'),
        ParallaxImageData('background_front.png'),
      ],
      baseVelocity: Vector2(10, 0),
      velocityMultiplierDelta: Vector2(1.8, 1.0),
    );
    add(parallax);

    // Add the floating title text with a gentle up/down movement.
    add(
      TextComponent(
        text: 'Alesia',
        position: size / 2,
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 64,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
        ..add(
          MoveEffect.by(
            Vector2(0, 20),
            EffectController(
              duration: 2,
              alternate: true,
              infinite: true,
            ),
          ),
        ),
    );

    // Define menu items with their asset names and destination routes.
    final List<({String asset, String route})> items = [
      (asset: 'icon_harp.png', route: '/instruments'),
      (asset: 'icon_music_box.png', route: '/songs'),
      (asset: 'icon_storybook.png', route: '/stories'),
      (asset: 'icon_block_a.png', route: '/games'),
      (asset: 'icon_shell.png', route: '/sounds'),
    ];

    // Precalculate positions for the buttons on screen.
    final positions = [
      Vector2(size.x * 0.2, size.y * 0.75),
      Vector2(size.x * 0.35, size.y * 0.8),
      Vector2(size.x * 0.5, size.y * 0.75),
      Vector2(size.x * 0.65, size.y * 0.8),
      Vector2(size.x * 0.8, size.y * 0.75),
    ];

    // Create and add each menu button.
    for (var i = 0; i < items.length; i++) {
      final button = _MenuButton(
        asset: items[i].asset,
        route: items[i].route,
      )
        ..position = positions[i]
        ..size = Vector2.all(size.y * 0.2)
        ..anchor = Anchor.center;
      add(button);
    }
  }
}

/// A button component used on the home screen.
///
/// This component loads a sprite from the given asset, reacts to taps
/// with a scale effect and triggers navigation and sound effects via
/// service locators.
class _MenuButton extends SpriteComponent with TapCallbacks {
  _MenuButton({required this.asset, required this.route});

  final String asset;
  final String route;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await Sprite.load(asset);
  }

  @override
  void onTapDown(TapDownEvent event) {
    // Shrink slightly when pressed.
    add(
      ScaleEffect.to(
        Vector2.all(0.9),
        EffectController(duration: 0.1),
      ),
    );
  }

  @override
  void onTapUp(TapUpEvent event) {
    // Bounce back to original size and navigate once the effect completes.
    add(
      ScaleEffect.to(
        Vector2.all(1.0),
        EffectController(duration: 0.1),
        onComplete: () {
          // Navigate to the route via GoRouter and play a UI sound.
          locator<GoRouter>().go(route);
          locator<AudioEngineService>().playSample('assets/audio/ui/sfx_1.wav');
        },
      ),
    );
  }
}