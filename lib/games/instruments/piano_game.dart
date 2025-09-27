import 'dart:math';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/audio_service.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class PianoGame extends FlameGame with HasTappables {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewport = FixedResolutionViewport(Vector2(1080, 1920));

    const int keys = 7;
    final double margin = 20;
    final double keyWidth = (1080 - margin * (keys + 1)) / keys;
    final double keyHeight = 380;

    for (int i = 0; i < keys; i++) {
      final x = margin + i * (keyWidth + margin);
      final y = 1920 - keyHeight - 80;
      final key = _InstrumentPad(
        label: ['Do','Re','Mi','Fa','Sol','La','Si'][i],
        // TODO (Răzvan): Înlocuiește sprite-ul placeholder cu o clapă finală 'clapa_[culoare].png'
        spritePath: 'placeholders/placeholder_square.png',
        size: Vector2(keyWidth, keyHeight),
        position: Vector2(x + keyWidth/2, y + keyHeight/2),
      );
      add(key);
    }
  }
}

class _InstrumentPad extends SpriteComponent with TapCallbacks, HasGameRef<PianoGame> {
  final String label;
  _InstrumentPad({required this.label, required String spritePath, super.size, super.position}) {
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
      textRenderer: TextPaint(style: const TextStyle(fontSize: 36, color: Colors.black, fontWeight: FontWeight.bold)),
    ));
    add(RoundedRectangleComponent(radius: 22, size: size, paint: Paint()..color = Colors.white.withOpacity(0.0001)));
  }

  @override
  void onTapDown(TapDownEvent event) {
    add(ScaleEffect.to(Vector2(0.98, 0.94), EffectController(duration: 0.06, curve: Curves.easeOut)));
  }

  @override
  void onTapUp(TapUpEvent event) {
    add(ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.12, curve: Curves.easeOutBack)));
    getIt<AudioService>().playTap();
    _burstEffect();
  }

  void _burstEffect() {
    final rnd = Random();
    final particle = ParticleSystemComponent(
      particle: Particle.generate(
        count: 30,
        lifespan: 0.6,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, 600),
          speed: Vector2((rnd.nextDouble()-0.5)*250, -rnd.nextDouble()*350),
          position: center.clone(),
          child: CircleParticle(radius: 1.5 + rnd.nextDouble()*2.5, paint: Paint()..color = const Color(0xFF673AB7)),
        ),
      ),
    );
    game.add(particle);
  }
}
