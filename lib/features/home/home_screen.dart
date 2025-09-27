import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:alesia/services/ab_service.dart';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/parental_control_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children:[
        GameWidget(
        game: HomeGame(router: GoRouter.of(context)),
      ),
        SafeArea(
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton.small(
                    heroTag: 'fab_profile',
                    onPressed: () => Navigator.of(context).pushNamed('/profil'),
                    child: const Icon(Icons.face),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton.small(
                    heroTag: 'fab_quests',
                    onPressed: () => Navigator.of(context).pushNamed('/questuri'),
                    child: const Icon(Icons.flag),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton.small(
                    heroTag: 'fab_parent',
                    onPressed: () async {
                      // Gate simplu prin PIN
                      final ok = await Navigator.of(context).pushNamed('/parinti/setari');
                    },
                    child: const Icon(Icons.lock),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class HomeGame extends FlameGame with HasTappables {
  final GoRouter router;
  HomeGame({required this.router});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Make asset paths explicit for Flame
    images.prefix = 'assets/images/';

    // TODO (Răzvan): Înlocuiește cu resursa finală 'parallax_back.png'.
    final back = ParallaxImageData('placeholders/placeholder_landscape.png');
    // TODO (Răzvan): Înlocuiește cu resursa finală 'parallax_middle.png'.
    final middle = ParallaxImageData('placeholders/placeholder_landscape.png');
    // TODO (Răzvan): Înlocuiește cu resursa finală 'parallax_front.png'.
    final front = ParallaxImageData('placeholders/placeholder_landscape.png');

    final parallaxComponent = await loadParallaxComponent(
      [back, middle, front],
      baseVelocity: Vector2(10, 0),
      velocityMultiplierDelta: Vector2(1.4, 0),
    );
    add(parallaxComponent);

    final title = TextComponent(
      text: 'Alesia',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 80,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          shadows: [Shadow(color: Colors.black54, offset: Offset(3, 3), blurRadius: 5)],
        ),
      ),
      anchor: Anchor.topCenter,
      position: Vector2(size.x / 2, size.y * 0.12),
    );
    title.add(SequenceEffect([
      MoveByEffect(Vector2(0, 18), EffectController(duration: 2.2, curve: Curves.easeInOut)),
      MoveByEffect(Vector2(0, -18), EffectController(duration: 2.2, curve: Curves.easeInOut)),
    ], infinite: true));
    add(title);
    
    final buttonsData = [
      {'asset': 'harp.png', 'route': '/instrumente'},
      {'asset': 'music_box.png', 'route': '/canciones'},
      {'asset': 'story_book.png', 'route': '/povesti'},
      {'asset': 'play_cube.png', 'route': '/jocuri'},
      {'asset': 'seashell.png', 'route': '/sunete'},
    ];

    const double buttonSize = 120;
    const double buttonSpacing = 28;
    final double totalWidth = (buttonSize * buttonsData.length) + (buttonSpacing * (buttonsData.length - 1));
    double startX = (size.x - totalWidth) / 2;
    
    for (var data in buttonsData) {
      final button = MenuButton(
        finalAssetName: data['asset']!,
        onPressed: () => router.push(data['route']!),
      )
        ..size = Vector2.all(buttonSize)
        ..position = Vector2(startX, size.y * 0.62);
      add(button);
      startX += buttonSize + buttonSpacing;
    }
  }
}

class MenuButton extends SpriteComponent with TapCallbacks {
  final String finalAssetName;
  final VoidCallback onPressed;

  MenuButton({required this.finalAssetName, required this.onPressed}) : super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    // Flame image prefix is 'assets/images/'
    // TODO (Răzvan): Înlocuiește cu resursa finală folosind: 'final/' + finalAssetName
    sprite = await Sprite.load('placeholders/placeholder_square.png');
    add(SequenceEffect([
      ScaleEffect.to(Vector2.all(1.05), EffectController(duration: 0.6, curve: Curves.easeOutBack)),
      ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.6, curve: Curves.easeInOutBack)),
    ], infinite: true));
  }
  
  @override
  void onTapDown(TapDownEvent event) {
    add(ScaleEffect.to(Vector2.all(0.9), EffectController(duration: 0.08, curve: Curves.easeOut)));
  }

  @override
  void onTapUp(TapUpEvent event) {
    add(SequenceEffect([
      ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.12, curve: Curves.elasticOut)),
      RotateEffect.by(0.15, EffectController(duration: 0.12, curve: Curves.easeOut)),
      RotateEffect.to(0, EffectController(duration: 0.14, curve: Curves.easeIn)),
    ]));
    onPressed();
  }
}
