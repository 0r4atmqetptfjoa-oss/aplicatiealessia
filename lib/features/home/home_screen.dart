import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/audio_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GameWidget(
        game: HomeGame(router: GoRouter.of(context)),
      ),
    );
  }
}

class HomeGame extends FlameGame with HasTappables, TapCallbacks {
  final GoRouter router;
  HomeGame({required this.router});

  late final AudioService _audio;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _audio = getIt<AudioService>();

    final layers = <ParallaxImageData>[
      // TODO (Răzvan): Înlocuiește cu resursa finală 'parallax_back.png'.
      ParallaxImageData('images/placeholders/placeholder_landscape.png'),
      // TODO (Răzvan): Înlocuiește cu resursa finală 'parallax_middle.png'.
      ParallaxImageData('images/placeholders/placeholder_landscape.png'),
      // TODO (Răzvan): Înlocuiește cu resursa finală 'parallax_front.png'.
      ParallaxImageData('images/placeholders/placeholder_landscape.png'),
    ];

    final parallaxComponent = await loadParallaxComponent(
      layers,
      baseVelocity: Vector2(0, 0),
      velocityMultiplierDelta: Vector2(0.5, 0),
    );
    add(parallaxComponent);

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
      position: Vector2(size.x / 2, size.y * 0.12),
    );

    title.add(SequenceEffect([
      MoveByEffect(Vector2(0, 14), EffectController(duration: 2.2, curve: Curves.easeInOut)),
      MoveByEffect(Vector2(0, -14), EffectController(duration: 2.2, curve: Curves.easeInOut)),
    ], infinite: true));
    add(title);

    final buttons = [
      {'asset': 'harp.png', 'route': '/instrumente', 'label': 'Instrumente'},
      {'asset': 'music_box.png', 'route': '/canciones', 'label': 'Cântece'},
      {'asset': 'story_book.png', 'route': '/povesti', 'label': 'Povești'},
      {'asset': 'play_cube.png', 'route': '/jocuri', 'label': 'Jocuri'},
      {'asset': 'seashell.png', 'route': '/sunete', 'label': 'Sunete'},
    ];

    const double buttonSize = 110;
    const double spacing = 26;
    final double totalWidth = (buttonSize * buttons.length) + (spacing * (buttons.length - 1));
    double startX = (size.x - totalWidth) / 2;

    for (final data in buttons) {
      final b = MenuButton(
        finalAssetName: data['asset']!,
        label: data['label']!,
        onPressed: () {
          _audio.playTap();
          router.push(data['route']!);
        },
      )
        ..size = Vector2.all(buttonSize)
        ..position = Vector2(startX, size.y * 0.62);
      add(b);
      startX += buttonSize + spacing;
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    // O mică ploaie de particule pentru "juicy feedback".
    final origin = event.localPosition.toVector2();
    add(ParticleSystemComponent(
      position: origin,
      particle: Particle.generate(
        count: 16,
        lifespan: 0.6,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, 600),
          speed: Vector2.random()..scale(180)..y = -220,
          child: CircleParticle(
            radius: 3,
            paint: Paint()..color = Colors.white.withOpacity(0.9),
          ),
        ),
      ),
    ));
  }
}

class MenuButton extends SpriteComponent with TapCallbacks, HasGameRef<HomeGame> {
  final String finalAssetName;
  final String label;
  final VoidCallback onPressed;

  MenuButton({required this.finalAssetName, required this.onPressed, required this.label});

  late TextComponent _caption;

  @override
  Future<void> onLoad() async {
    // TODO (Răzvan): Înlocuiește cu resursa finală: 'images/final/$finalAssetName'.
    sprite = await Sprite.load('images/placeholders/placeholder_square.png');

    _caption = TextComponent(
      text: label,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.w700,
          shadows: [Shadow(color: Colors.black54, offset: Offset(2, 2), blurRadius: 4)],
        ),
      ),
      anchor: Anchor.topCenter,
      position: Vector2(size.x / 2, size.y + 8),
    );
    add(_caption);
  }

  @override
  void onTapDown(TapDownEvent event) {
    add(ScaleEffect.to(Vector2.all(0.92), EffectController(duration: 0.08, curve: Curves.easeOutBack)));
    add(RotateEffect.by(0.1, EffectController(duration: 0.1)));
  }

  @override
  void onTapUp(TapUpEvent event) {
    add(SequenceEffect([
      ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.12, curve: Curves.easeOutBack)),
      RotateEffect.to(0, EffectController(duration: 0.1)),
    ]));
    onPressed();
  }
}
