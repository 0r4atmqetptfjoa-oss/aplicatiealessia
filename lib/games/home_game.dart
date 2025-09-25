import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart' hide Image;

/// Signature for a callback that initiates navigation to another route.
typedef NavigateCallback = void Function(String route);

/// A small Flame game used to render the main menu scene.
///
/// The scene consists of a parallax background made from three separate
/// layers, a floating title and a row of interactive buttons.  Each
/// button triggers navigation to a different placeholder route when tapped.
class HomeGame extends FlameGame with HasTappables {
  HomeGame({required this.onNavigate});

  /// Callback invoked when the user taps one of the menu buttons.
  final NavigateCallback onNavigate;

  /// Provide a custom camera zoom so that the scene scales nicely across
  /// devices with different resolutions.  A smaller zoom shows more of the
  /// parallax art.
  @override
  double get zoom => 1.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Preload the image assets referenced by the parallax and buttons.
    await images.loadAll([
      'background_back.png',
      'background_middle.png',
      'background_front.png',
      'icon_harp.png',
      'icon_music_box.png',
      'icon_storybook.png',
      'icon_block_a.png',
      'icon_shell.png',
    ]);

    // Build the parallax from back to front.  The base velocity controls
    // the scroll speed of the nearest layer; farther layers move more
    // slowly by default.  The velocityMultiplierDelta scales down the
    // velocity per layer so that the farthest layer moves the least.
    final ParallaxComponent parallax = await loadParallaxComponent(
      [
        ParallaxImageData('background_back.png'),
        ParallaxImageData('background_middle.png'),
        ParallaxImageData('background_front.png'),
      ],
      baseVelocity: Vector2(5, 0),
      velocityMultiplierDelta: Vector2(1.5, 0),
      // The parallax component will size itself to the game viewport.
    );
    add(parallax);

    // Add the animated title.  A floating effect makes the text gently
    // oscillate up and down to feel alive.
    final title = TextComponent(
      text: 'Alesia',
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 64,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          shadows: [
            Shadow(
              offset: const Offset(2, 2),
              blurRadius: 4,
              color: Colors.black.withOpacity(0.3),
            ),
          ],
        ),
      ),
    )
      ..anchor = Anchor.center
      ..position = Vector2(size.x / 2, size.y * 0.25);
    // Create a perpetual floating effect.
    title.add(
      MoveEffect.by(
        Vector2(0, -10),
        EffectController(
          duration: 2,
          reverseDuration: 2,
          infinite: true,
          curve: Curves.easeInOut,
        ),
      ),
    );
    add(title);

    // Define the menu items: asset name and destination route.
    final List<({String asset, String route})> items = [
      (asset: 'icon_harp.png', route: '/instruments'),
      (asset: 'icon_music_box.png', route: '/songs'),
      (asset: 'icon_storybook.png', route: '/stories'),
      (asset: 'icon_block_a.png', route: '/games'),
      (asset: 'icon_shell.png', route: '/sounds'),
    ];

    // Layout variables for the buttons.
    const double buttonSize = 96;
    const double horizontalSpacing = 24;
    final double totalWidth = items.length * buttonSize + (items.length - 1) * horizontalSpacing;
    double xStart = (size.x - totalWidth) / 2 + buttonSize / 2;
    final double yPos = size.y * 0.7;

    // Create and add each menu button.
    for (final item in items) {
      final sprite = await loadSprite(item.asset);
      final button = _MenuButton(
        sprite: sprite,
        size: Vector2.all(buttonSize),
        onTap: () => onNavigate(item.route),
      )
        ..anchor = Anchor.center
        ..position = Vector2(xStart, yPos);
      add(button);
      xStart += buttonSize + horizontalSpacing;
    }
  }
}

/// Private helper component representing an interactive menu button.
///
/// The button scales down slightly when pressed and springs back with an
/// elastic effect when released.  When tapped, it invokes the supplied
/// [onTap] callback.
class _MenuButton extends SpriteComponent with Tappable {
  _MenuButton({
    required Sprite sprite,
    required Vector2 size,
    required this.onTap,
  }) : super(sprite: sprite, size: size);

  final VoidCallback onTap;

  bool _pressed = false;

  @override
  bool onTapDown(TapDownEvent event) {
    _pressed = true;
    // Start a quick squash effect when the user presses down.
    add(
      ScaleEffect.to(
        Vector2(0.85, 0.85),
        EffectController(duration: 0.1, curve: Curves.easeOut),
      ),
    );
    return true;
  }

  @override
  bool onTapUp(TapUpEvent event) {
    if (_pressed) {
      _pressed = false;
      // Stretch past the original size then settle back to 1.0 with an
      // elastic easing curve.
      add(
        ScaleEffect.to(
          Vector2(1.15, 1.15),
          EffectController(duration: 0.2, reverseDuration: 0.2, curve: Curves.easeOutBack),
          onComplete: () {
            // Reset to original scale and call callback once the effect is
            // complete.  Use microtask to avoid interfering with Flame's
            // internals.
            scale = Vector2.all(1.0);
            Future.microtask(onTap);
          },
        ),
      );
    }
    return true;
  }

  @override
  bool onTapCancel() {
    _pressed = false;
    // If the touch is cancelled, smoothly return to original scale.
    add(
      ScaleEffect.to(
        Vector2(1.0, 1.0),
        EffectController(duration: 0.1, curve: Curves.easeOut),
      ),
    );
    return true;
  }
}