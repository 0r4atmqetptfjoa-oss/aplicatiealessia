import 'dart:math';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/audio_service.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum HitResult { perfect, good, miss }

/// Bază pentru jocurile de instrumente: scor, combo, BPM, particule și judecata ritmică.
abstract class BaseInstrumentGame extends FlameGame with HasTappables {
  BaseInstrumentGame({double bpm = 100}) : _bpm = bpm {
    _spb = 60.0 / _bpm;
  }

  final double _bpm;
  late double _spb;
  double _t = 0;

  // HUD bindings
  final ValueNotifier<int> score = ValueNotifier<int>(0);
  final ValueNotifier<int> combo = ValueNotifier<int>(0);
  final ValueNotifier<String> fairyAnim = ValueNotifier<String>('idle');
  final ValueNotifier<double> beatPhase = ValueNotifier<double>(0); // 0..1

  Color primaryColor = const Color(0xFF673AB7);

  @override
  void update(double dt) {
    super.update(dt);
    _t += dt;
    beatPhase.value = (_t % _spb) / _spb;
  }

  /// Apelează acest helper când un pad/clapă este apăsat(ă).
  Future<HitResult> onPadTriggered({required int midi, required Vector2 worldPosition}) async {
    final result = _judge();
    _applyResult(result);
    _spawnBurst(worldPosition, result);
    // Redă nota (fallback la click placeholder dacă nu există asset-ul final).
    await getIt<AudioService>().playNote(instrument: instrumentKey, midi: midi);
    return result;
  }

  /// Cheie textuală a instrumentului pentru căile audio finale. Ex: 'piano', 'drums'.
  String get instrumentKey;

  HitResult _judge() {
    final beats = _t / _spb;
    final nearestBeat = beats.roundToDouble();
    final diff = (_t - nearestBeat * _spb).abs();
    if (diff <= 0.12) return HitResult.perfect;
    if (diff <= 0.22) return HitResult.good;
    return HitResult.miss;
  }

  void _applyResult(HitResult r) {
    switch (r) {
      case HitResult.perfect:
        score.value += 100 + (combo.value * 2);
        combo.value += 1;
        _updateFairy();
        break;
      case HitResult.good:
        score.value += 60 + (combo.value);
        combo.value += 1;
        _updateFairy();
        break;
      case HitResult.miss:
        combo.value = 0;
        _updateFairy();
        _shake();
        break;
    }
  }

  void _updateFairy() {
    if (combo.value >= 12) {
      fairyAnim.value = 'dance_fast';
    } else if (combo.value >= 4) {
      fairyAnim.value = 'dance_slow';
    } else if (combo.value == 0) {
      fairyAnim.value = 'idle';
    }
  }

  void _shake() {
    // Mic shake de ecran
    add(SequenceEffect([
      MoveByEffect(Vector2(6, 0), EffectController(duration: 0.03)),
      MoveByEffect(Vector2(-12, 0), EffectController(duration: 0.06)),
      MoveByEffect(Vector2(6, 0), EffectController(duration: 0.03)),
    ]));
  }

  void _spawnBurst(Vector2 pos, HitResult r) {
    final rnd = Random();
    int count = r == HitResult.perfect ? 36 : (r == HitResult.good ? 22 : 10);
    final baseColor = r == HitResult.miss ? const Color(0xFFBDBDBD) : primaryColor;

    final particle = ParticleSystemComponent(
      priority: 1000,
      position: pos,
      particle: Particle.generate(
        count: count,
        lifespan: 0.55,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, 700),
          speed: Vector2((rnd.nextDouble()-0.5)* (r == HitResult.perfect ? 360 : 240),
                         -rnd.nextDouble() * (r == HitResult.perfect ? 420 : 320)),
          child: CircleParticle(
            radius: 1.5 + rnd.nextDouble() * (r == HitResult.perfect ? 3.0 : 2.2),
            paint: Paint()..color = baseColor.withOpacity(0.9 - rnd.nextDouble()*0.4),
          ),
        ),
      ),
    );
    add(particle);
  }
}
