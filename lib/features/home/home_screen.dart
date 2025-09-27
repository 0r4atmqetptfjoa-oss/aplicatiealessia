import 'dart:math';
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
      body: GameWidget(
        game: HomeGame(router: GoRouter.of(context)),
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
      ParallaxImageData('placeholders/placeholder_landscape.png'),
      ParallaxImageData('placeholders/placeholder_landscape.png'),
      ParallaxImageData('placeholders/placeholder_landscape.png'),
    ];
    
    final parallaxComponent = await loadParallaxComponent(
      parallaxLayers,
      baseVelocity: Vector2.zero(),
      repeat: ImageRepeat.repeat,
    );
    add(parallaxComponent);

    final title = TextComponent(
      text: 'Alesia',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 80,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.black54, offset: Offset(3, 3), blurRadius: 5),
          ],
        ),
      ),
      anchor: Anchor.topCenter,
      position: Vector2(size.x / 2, size.y * 0.15),
    );

    title.add(
      SequenceEffect([
        MoveByEffect(Vector2(0, 15), EffectController(duration: 2.5, curve: Curves.easeInOut)),
        MoveByEffect(Vector2(0, -15), EffectController(duration: 2.5, curve: Curves.easeInOut)),
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
    const double buttonSpacing = 30;
    final double totalWidth = (buttonSize * buttonsData.length) + (buttonSpacing * (buttonsData.length - 1));
    double startX = (size.x - totalWidth) / 2;
    final y = size.y * 0.65;
    
    for (var data in buttonsData) {
      final button = MenuButton(
        finalAssetName: data['asset']!,
        onPressed: () => router.push(data['route']!),
      )
      ..size = Vector2.all(buttonSize)
      ..position = Vector2(startX, y);
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
    // sprite = await Sprite.load('final/$finalAssetName');
    sprite = await Sprite.load('placeholders/placeholder_square.png');
    anchor = Anchor.center;
  }

  @override
  void onMount() {
    super.onMount();
    // Spawn a subtle bobbing animation
    add(SequenceEffect([
      ScaleEffect.to(Vector2.all(1.06), EffectController(duration: 0.5, curve: Curves.easeOut)),
      ScaleEffect.to(Vector2.all(1.00), EffectController(duration: 0.9, curve: Curves.easeInOut)),
    ], infinite: true));
  }
  
  @override
  void onTapDown(TapDownEvent event) {
    add(SequenceEffect([
      ScaleEffect.to(Vector2.all(0.92), EffectController(duration: 0.08, curve: Curves.easeOutBack)),
      RotateEffect.by(0.06, EffectController(duration: 0.08)),
    ]));
  }

  @override
  void onTapUp(TapUpEvent event) {
    add(SequenceEffect([
      ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.10, curve: Curves.easeOut)),
      RotateEffect.to(0, EffectController(duration: 0.10)),
    ]));
    _burstEffect(center);
    onPressed();
  }

  void _burstEffect(Vector2 pos) {
    final rnd = Random();
    final particle = ParticleSystemComponent(
      particle: Particle.generate(
        count: 22,
        lifespan: 0.5,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, 600),
          speed: Vector2((rnd.nextDouble()-0.5)*400, -rnd.nextDouble()*300),
          position: pos.clone(),
          child: CircleParticle(radius: 2 + rnd.nextDouble()*3, paint: Paint()..color = const Color(0xFFFFFFFF)),
        ),
      ),
    );
    game.add(particle);
  }
}
