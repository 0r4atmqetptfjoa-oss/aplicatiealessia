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
      body: SafeArea(
        child: GameWidget(
          game: HomeGame(router: GoRouter.of(context)),
        ),
      ),
    );
  }
}

class HomeGame extends FlameGame with HasTappables, HasHoverables {
  final GoRouter router;
  HomeGame({required this.router});

  late ParallaxComponent _parallax;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Parallax cu 3 straturi (placeholdere 16:9).
    // TODO (Răzvan): Înlocuiește placeholder-ele cu resursele finale din /final:
    // ParallaxImageData('final/parallax_back.png'),
    // ParallaxImageData('final/parallax_middle.png'),
    // ParallaxImageData('final/parallax_front.png'),
    final parallaxLayers = [
      ParallaxImageData('placeholders/placeholder_landscape.png'),
      ParallaxImageData('placeholders/placeholder_landscape.png'),
      ParallaxImageData('placeholders/placeholder_landscape.png'),
    ];

    _parallax = await loadParallaxComponent(
      parallaxLayers,
      baseVelocity: Vector2(2, 0),
      velocityMultiplierDelta: Vector2(1.4, 0),
      repeat: ImageRepeat.repeatX,
    );
    add(_parallax);

    final title = TextComponent(
      text: 'Alesia',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 76,
          color: Colors.white,
          fontWeight: FontWeight.w900,
          shadows: [Shadow(color: Colors.black54, offset: Offset(3, 3), blurRadius: 6)],
        ),
      ),
      anchor: Anchor.topCenter,
      position: Vector2(size.x / 2, size.y * 0.08),
    );

    // 'Floating' loop (suav, elastic)
    title.add(
      SequenceEffect([
        MoveByEffect(Vector2(0, 16), EffectController(duration: 2.2, curve: Curves.easeInOut)),
        MoveByEffect(Vector2(0, -16), EffectController(duration: 2.2, curve: Curves.easeInOut)),
      ], infinite: true),
    );
    add(title);

    final buttonsData = [
      {'asset': 'harp.png', 'route': '/instrumente'},
      {'asset': 'music_box.png', 'route': '/canciones'},
      {'asset': 'story_book.png', 'route': '/povesti'},
      {'asset': 'play_cube.png', 'route': '/jocuri'},
      {'asset': 'seashell.png', 'route': '/sunete'},
    ];

    const double buttonSize = 120;
    const double spacing = 26;
    final double totalWidth = (buttonSize * buttonsData.length) + (spacing * (buttonsData.length - 1));
    double startX = (size.x - totalWidth) / 2;

    for (var data in buttonsData) {
      final button = MenuButton(
        finalAssetName: data['asset']!,
        onPressed: () => router.push(data['route']!),
      )
        ..size = Vector2.all(buttonSize)
        ..position = Vector2(startX, size.y * 0.62);
      add(button);
      startX += buttonSize + spacing;
    }
  }
}

class MenuButton extends SpriteComponent with TapCallbacks {
  final String finalAssetName;
  final VoidCallback onPressed;

  MenuButton({required this.finalAssetName, required this.onPressed});

  @override
  Future<void> onLoad() async {
    // TODO (Răzvan): Înlocuiește placeholder-ul cu resursa finală:
    // sprite = await Sprite.load('final/$finalAssetName');
    sprite = await Sprite.load('placeholders/placeholder_square.png');
    anchor = Anchor.center;
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
      ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.12, curve: Curves.elasticOut)),
      RotateEffect.to(0, EffectController(duration: 0.10, curve: Curves.easeOut)),
    ]));
    onPressed();
  }
}
