import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GameWidget(game: HomeGame(router: GoRouter.of(context))),
    );
  }
}

class HomeGame extends FlameGame {
  final GoRouter router;
  HomeGame({required this.router});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // TODO (Răzvan): Înlocuiește cu parallax_final (back/middle/front)
    final parallaxLayers = [
      ParallaxImageData('images/placeholders/placeholder_landscape.png'),
      ParallaxImageData('images/placeholders/placeholder_landscape.png'),
      ParallaxImageData('images/placeholders/placeholder_landscape.png'),
    ];
    final parallaxComponent = await loadParallaxComponent(parallaxLayers, baseVelocity: Vector2.zero());
    add(parallaxComponent);

    final title = TextComponent(
      text: 'Alesia',
      textRenderer: TextPaint(
        style: TextStyle(fontSize: 72, color: Colors.white, fontWeight: FontWeight.bold, shadows: [
          const Shadow(color: Colors.black54, offset: Offset(3, 3), blurRadius: 5),
        ]),
      ),
      anchor: Anchor.topCenter,
      position: Vector2(size.x / 2, size.y * 0.15),
    );
    title.add(SequenceEffect([
      MoveByEffect(Vector2(0, 15), EffectController(duration: 2.0, curve: Curves.easeInOut)),
      MoveByEffect(Vector2(0, -15), EffectController(duration: 2.0, curve: Curves.easeInOut)),
    ], infinite: true));
    add(title);

    final buttons = [
      {'asset': 'harp.png', 'route': '/instrumente'},
      {'asset': 'music_box.png', 'route': '/canciones'},
      {'asset': 'story_book.png', 'route': '/povesti'},
      {'asset': 'play_cube.png', 'route': '/jocuri'},
      {'asset': 'seashell.png', 'route': '/sunete'},
    ];

    const double buttonSize = 96;
    const double buttonSpacing = 28;
    final double totalWidth = (buttonSize * buttons.length) + (buttonSpacing * (buttons.length - 1));
    double startX = (size.x - totalWidth) / 2;

    for (var data in buttons) {
      final b = _MenuButton(
        finalAssetName: data['asset']!,
        onPressed: () => router.push(data['route']!),
      )
        ..size = Vector2.all(buttonSize)
        ..position = Vector2(startX, size.y * 0.65);
      add(b);
      startX += buttonSize + buttonSpacing;
    }
  }
}

class _MenuButton extends SpriteComponent with TapCallbacks {
  final String finalAssetName;
  final VoidCallback onPressed;
  _MenuButton({required this.finalAssetName, required this.onPressed});

  @override
  Future<void> onLoad() async {
    // TODO (Răzvan): Înlocuiește placeholder-ul cu resursa finală:
    // sprite = await Sprite.load('images/final/$finalAssetName');
    sprite = await Sprite.load('images/placeholders/placeholder_square.png');
  }

  @override
  void onTapDown(TapDownEvent event) {
    add(SequenceEffect([
      ScaleEffect.to(Vector2.all(0.9), EffectController(duration: 0.08, curve: Curves.easeOut)),
      RotateEffect.by(0.08, EffectController(duration: 0.08)),
    ]));
  }

  @override
  void onTapUp(TapUpEvent event) {
    add(SequenceEffect([
      ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.08, curve: Curves.easeIn)),
      RotateEffect.to(0, EffectController(duration: 0.08)),
    ]));
    onPressed();
  }
}
