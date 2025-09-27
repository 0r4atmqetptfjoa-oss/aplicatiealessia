import 'dart:math';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/audio_service.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class DrumsGame extends FlameGame with HasTappables {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewport = FixedResolutionViewport(Vector2(1080, 1920));

    final positions = [
      Vector2(360, 740), Vector2(720, 740),
      Vector2(360, 1160), Vector2(720, 1160),
    ];

    for (int i = 0; i < positions.length; i++) {
      add(_DrumPad(
        label: 'Pad ${i+1}',
        // TODO (Răzvan): Înlocuiește sprite-ul placeholder cu un pad final de tobă 'toba_[culoare].png'
        spritePath: 'placeholders/placeholder_square.png',
        position: positions[i],
        size: Vector2(280, 280),
      ));
    }
  }
}

class _DrumPad extends SpriteComponent with TapCallbacks, HasGameRef<DrumsGame> {
  final String label;
  _DrumPad({required this.label, required String spritePath, required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.center) {
    _spritePath = spritePath;
  }

  late final String _spritePath;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(_spritePath);
    add(TextComponent(
      text: label,
      anchor: Anchor.center,
      position: Vector2(0, size.y * 0.35),
      textRenderer: TextPaint(style: const TextStyle(fontSize: 28, color: Colors.black, fontWeight: FontWeight.bold)),
    ));
  }

  @override
  void onTapDown(TapDownEvent event) {
    add(ScaleEffect.to(Vector2.all(0.9), EffectController(duration: 0.06, curve: Curves.easeOut)));
  }

  @override
  void onTapUp(TapUpEvent event) {
    add(ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.12, curve: Curves.easeOutBack)));
    add(RotateEffect.by(0.1, EffectController(duration: 0.08)));
    getIt<AudioService>().playTap();
    _burstEffect();
  }

  void _burstEffect() {
    final rnd = Random();
    final particle = ParticleSystemComponent(
      particle: Particle.generate(
        count: 20,
        lifespan: 0.4,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, 700),
          speed: Vector2((rnd.nextDouble()-0.5)*300, -rnd.nextDouble()*300),
          position: center.clone(),
          child: CircleParticle(radius: 2 + rnd.nextDouble()*3, paint: Paint()..color = const Color(0xFFEF6C00)),
        ),
      ),
    );
    game.add(particle);
  }
}
