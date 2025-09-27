import 'dart:math';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/audio_service.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class OrganGame extends FlameGame with HasTappables {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewport = FixedResolutionViewport(Vector2(1080, 1920));

    const int shells = 5;
    final double margin = 24;
    final double width = (1080 - margin * (shells + 1)) / shells;
    final double height = 340;
    final double baseY = 1920 - height - 100;

    for (int i = 0; i < shells; i++) {
      final x = margin + i * (width + margin);
      final y = baseY - (i % 2) * 20;
      add(_ShellKey(
        label: 'S${i+1}',
        // TODO (Răzvan): Înlocuiește sprite-ul placeholder cu clapă-scoică finală 'scoica_[i].png'
        spritePath: 'placeholders/placeholder_square.png',
        size: Vector2(width, height),
        position: Vector2(x + width/2, y + height/2),
      ));
    }
  }
}

class _ShellKey extends SpriteComponent with TapCallbacks, HasGameRef<OrganGame> {
  final String label;
  _ShellKey({required this.label, required String spritePath, super.size, super.position}) {
    _spritePath = spritePath;
    anchor = Anchor.center;
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
    add(SequenceEffect([
      ScaleEffect.to(Vector2(0.96, 0.9), EffectController(duration: 0.06, curve: Curves.easeOut)),
      MoveByEffect(Vector2(0, 6), EffectController(duration: 0.06)),
    ]));
  }

  @override
  void onTapUp(TapUpEvent event) {
    add(SequenceEffect([
      ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.12, curve: Curves.easeOutBack)),
      MoveByEffect(Vector2(0, -6), EffectController(duration: 0.12, curve: Curves.easeOutBack)),
    ]));
    getIt<AudioService>().playTap();
    _burstEffect();
  }

  void _burstEffect() {
    final rnd = Random();
    final particle = ParticleSystemComponent(
      particle: Particle.generate(
        count: 26,
        lifespan: 0.55,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, 680),
          speed: Vector2((rnd.nextDouble()-0.5)*240, -rnd.nextDouble()*340),
          position: center.clone(),
          child: CircleParticle(radius: 2 + rnd.nextDouble()*2.5, paint: Paint()..color = const Color(0xFF7E57C2)),
        ),
      ),
    );
    game.add(particle);
  }
}
