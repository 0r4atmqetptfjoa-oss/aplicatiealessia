import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A widget that hosts the Flame game responsible for rendering the main menu.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GameWidget(
          game: HomeGame(router: GoRouter.of(context)),
        ),
      ),
    );
  }
}

/// The Flame game powering the home screen.
///
/// This scene uses a parallax background and several tappable sprite buttons
/// to navigate to other sections of the application. A floating title adds
/// a whimsical touch to the main menu.
class HomeGame extends FlameGame {
  HomeGame({required this.router});

  final GoRouter router;

  late final Vector2 _viewport;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Load parallax layers. The layers scroll at the same speed for a static
    // background. Adjust the velocity multipliers to create depth if desired.
    final parallax = await loadParallaxComponent(
      [
        ParallaxImageData('parallax_back.png'),
        ParallaxImageData('parallax_middle.png'),
        ParallaxImageData('parallax_front.png'),
      ],
      baseVelocity: Vector2.zero(),
      velocityMultiplierDelta: Vector2.zero(),
    );
    add(parallax);

    // Store the initial viewport size for positioning elements.
    _viewport = size;

    // Add a floating title.
    final title = TextComponent(
      text: 'Alesia',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 64,
          fontFamily: 'Arial',
          color: Colors.white,
          fontWeight: FontWeight.bold,
          shadows: [Shadow(color: Colors.black45, offset: Offset(2, 2), blurRadius: 4)],
        ),
      ),
    );
    title.anchor = Anchor.topCenter;
    title.position = Vector2(_viewport.x / 2, _viewport.y * 0.1);
    // Create a gentle floating effect using a sine-like up‑down motion.
    title.add(MoveByEffect(
      Vector2(0, 10),
      EffectController(
        duration: 2,
        infinite: true,
        reverseDuration: 2,
      ),
    ));
    add(title);

    // Load button sprites.
    final harpSprite = await loadSprite('harp.png');
    final musicSprite = await loadSprite('music_box.png');
    final bookSprite = await loadSprite('story_book.png');
    final cubeSprite = await loadSprite('play_cube.png');
    final shellSprite = await loadSprite('seashell.png');

    // Create buttons with callbacks.
    final buttons = <_MenuButton>[ 
      _MenuButton(
        sprite: harpSprite,
        // Navigate directly to the first instrument (piano) when the harp button is tapped.
        onPressed: () => router.go('/instrumente/pian'),
      ),
      _MenuButton(
        sprite: musicSprite,
        onPressed: () => router.go('/canciones'),
      ),
      _MenuButton(
        sprite: bookSprite,
        onPressed: () => router.go('/povesti'),
      ),
      _MenuButton(
        sprite: cubeSprite,
        onPressed: () => router.go('/jocuri'),
      ),
      _MenuButton(
        sprite: shellSprite,
        onPressed: () => router.go('/sunete'),
      ),
    ];

    // Define sizes and spacing for the buttons.
    const double buttonSize = 96;
    final double totalWidth = buttons.length * buttonSize + (buttons.length - 1) * 24;
    double startX = (_viewport.x - totalWidth) / 2;
    final double yPosition = _viewport.y * 0.65;

    for (final button in buttons) {
      button
        ..size = Vector2.all(buttonSize)
        ..anchor = Anchor.center
        ..position = Vector2(startX + buttonSize / 2, yPosition);
      add(button);
      startX += buttonSize + 24;
    }
  }
}

/// A tappable sprite that performs a bounce animation when pressed and triggers
/// a callback on release.
/// A tappable button that reacts to tap events and triggers a callback.
class _MenuButton extends SpriteComponent with TapCallbacks {
  _MenuButton({required Sprite sprite, required this.onPressed}) : super(sprite: sprite);

  final VoidCallback onPressed;

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    // Apply a squash and stretch effect when the button is pressed.
    add(ScaleEffect.to(
      Vector2(0.9, 1.1),
      EffectController(duration: 0.1),
      onComplete: () {
        add(ScaleEffect.to(
          Vector2.all(1.0),
          EffectController(duration: 0.1),
        ));
      },
    ));
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    // Trigger the callback on release.
    onPressed();
  }
}