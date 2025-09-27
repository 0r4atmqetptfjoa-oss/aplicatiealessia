import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Juicy {
  /// Confetti "explozie" la [pos] în [game].
  static void burst(FlameGame game, Vector2 pos, {Color color = Colors.white, int count = 28}) {
    final rnd = Random();
    final particle = ParticleSystemComponent(
      priority: 50,
      particle: Particle.generate(
        count: count,
        lifespan: 0.6,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, 900),
          speed: Vector2((rnd.nextDouble() - 0.5) * 600, -rnd.nextDouble() * 500),
          position: pos.clone(),
          child: CircleParticle(
            radius: 1.5 + rnd.nextDouble() * 3,
            paint: Paint()..color = color.withOpacity(0.95),
          ),
        ),
      ),
    );
    game.add(particle);
  }

  /// Ploaie de confetti pe tot ecranul.
  static void confettiRain(FlameGame game, {int streaks = 4}) {
    final rnd = Random();
    for (int s = 0; s < streaks; s++) {
      final particle = ParticleSystemComponent(
        priority: 49,
        particle: Particle.generate(
          count: 60,
          lifespan: 1.2,
          generator: (i) => AcceleratedParticle(
            acceleration: Vector2(0, 800),
            speed: Vector2((rnd.nextDouble() - 0.5) * 50, -rnd.nextDouble() * 600),
            position: Vector2(rnd.nextDouble() * game.size.x, -10),
            child: CircleParticle(
              radius: 2 + rnd.nextDouble() * 2,
              paint: Paint()
                ..color = HSLColor.fromAHSL(
                  1,
                  rnd.nextDouble() * 360,
                  0.75,
                  0.55,
                ).toColor(),
            ),
          ),
        ),
      );
      game.add(particle);
    }
  }
}
