import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

mixin ComboMixin on FlameGame {
  final ValueNotifier<int> combo = ValueNotifier<int>(0);
  int bestCombo = 0;

  void registerHit({Vector2? at, Color color = const Color(0xFFFFD54F)}) {
    combo.value += 1;
    if (combo.value > bestCombo) bestCombo = combo.value;
    _burst(at ?? (size / 2), color: color, intensity: 16 + min(combo.value, 24));
  }

  void registerMiss() {
    // Optional: efect special când se încheie un streak mare
    if (combo.value >= 8) {
      _burst(size / 2, color: const Color(0xFF80DEEA), intensity: 32);
    }
    combo.value = 0;
  }

  void _burst(Vector2 pos, {required Color color, int intensity = 24}) {
    final rnd = Random();
    add(ParticleSystemComponent(
      particle: Particle.generate(
        count: intensity,
        lifespan: 0.6,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, 650),
          speed: Vector2((rnd.nextDouble()-0.5) * 380, -rnd.nextDouble() * 420),
          position: pos.clone(),
          child: CircleParticle(
            radius: 1.5 + rnd.nextDouble() * 2.5,
            paint: Paint()..color = color,
          ),
        ),
      ),
    ));
  }
}
