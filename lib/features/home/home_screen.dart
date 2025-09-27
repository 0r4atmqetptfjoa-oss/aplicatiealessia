import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/audio_service.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/parental_control_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GameWidget(game: HomeGame(router: GoRouter.of(context))),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => GoRouter.of(context).push('/profil'),
                    icon: const Icon(Icons.account_circle),
                    label: const Text('Profil'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => GoRouter.of(context).push('/parinti'),
                    icon: const Icon(Icons.lock),
                    label: const Text('Părinți'),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton.icon(
                onPressed: () => GoRouter.of(context).push('/questuri'),
                icon: const Icon(Icons.flag),
                label: const Text('Questuri'),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton.icon(
                onPressed: () => GoRouter.of(context).push('/recompense'),
                icon: const Icon(Icons.emoji_events),
                label: const Text('Recompense'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeGame extends FlameGame {
  final GoRouter router;
  HomeGame({required this.router});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // TODO (Răzvan): Înlocuiește placeholder-ele cu resursele finale din /final:
    // ParallaxImageData('final/parallax_back.png'),
    // ParallaxImageData('final/parallax_middle.png'),
    // ParallaxImageData('final/parallax_front.png'),
    final parallaxLayers = [
      ParallaxImageData('images/placeholders/placeholder_landscape.png'),
      ParallaxImageData('images/placeholders/placeholder_landscape.png'),
      ParallaxImageData('images/placeholders/placeholder_landscape.png'),
    ];

    final parallaxComponent = await loadParallaxComponent(
      parallaxLayers,
      baseVelocity: Vector2.zero(),
      velocityMultiplierDelta: Vector2(0.4, 0),
    );
    add(parallaxComponent);

    final title = TextComponent(
      text: 'Alesia',
      anchor: Anchor.topCenter,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 84,
          color: Colors.white,
          fontWeight: FontWeight.w900,
          shadows: [Shadow(color: Colors.black54, offset: Offset(3, 3), blurRadius: 8)],
        ),
      ),
      position: Vector2(size.x / 2, size.y * 0.12),
    );

    title.add(
      SequenceEffect([
        ScaleEffect.to(Vector2.all(1.05), EffectController(duration: 0.9, curve: Curves.easeInOut)),
        ScaleEffect.to(Vector2.all(1.00), EffectController(duration: 0.9, curve: Curves.easeInOut)),
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
    const double buttonSpacing = 26;
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

class MenuButton extends SpriteComponent with TapCallbacks, HasGameRef<HomeGame> {
  final String finalAssetName;
  final VoidCallback onPressed;

  MenuButton({required this.finalAssetName, required this.onPressed});

  @override
  Future<void> onLoad() async {
    // TODO (Răzvan): Înlocuiește placeholder-ul cu resursa finală:
    // sprite = await Sprite.load('images/final/$finalAssetName');
    sprite = await Sprite.load('images/placeholders/placeholder_square.png');
    anchor = Anchor.center;
  }

  @override
  void onTapDown(TapDownEvent event) {
    add(SequenceEffect([
      ScaleEffect.to(Vector2.all(0.9), EffectController(duration: 0.07, curve: Curves.easeOutBack)),
      RotateEffect.by(0.12, EffectController(duration: 0.08, curve: Curves.easeOut)),
    ]));
  }

  @override
  void onTapUp(TapUpEvent event) {
    add(SequenceEffect([
      ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.12, curve: Curves.elasticOut)),
      RotateEffect.to(0, EffectController(duration: 0.10)),
    ]));
    // Play UI tap SFX (safe even if placeholder file is empty/missing)
    getIt<AudioService>().playUiTap();
    onPressed();
  }
}