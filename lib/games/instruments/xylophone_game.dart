import 'dart:math';
import 'package:alesia/core/game_feedback.dart';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/games/shared/rhythm_conductor.dart';
import 'package:alesia/services/audio_service.dart';
import 'package:alesia/services/analytics_service.dart';
import 'package:alesia/services/quests_service.dart';
import 'package:alesia/services/profile_service.dart';
import 'package:alesia/core/service_locator.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class XylophoneGame extends FlameGame with HasTappables {
  final GameFeedback feedback;
  XylophoneGame({required this.feedback},
      onTick: () => getIt<AudioService>().playTick(),
    );

  late RhythmConductor _conductor;
  late TextComponent _score;
  late TextComponent _prompt;
  late RectComponent _beatBar;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewport = FixedResolutionViewport(Vector2(1080, 1920));
    await getIt<AudioService>().preloadNotes(AudioService.defaultXyloMap());

    const int bars = 8;
    final double margin = 20;
    final double barWidth = (1080 - margin * (bars + 1)) / bars;
    final double barHeight = 300;

    for (int i = 0; i < bars; i++) {
      final x = margin + i * (barWidth + margin);
      final y = 1920 - barHeight - 120;
      add(_XyloBar(
        label: 'B${i+1}',
        // map to xylo:1..8
        semanticKey: 'xylo:${i+1}',
        // TODO (Răzvan): Înlocuiește sprite-ul placeholder cu bara finală de xilofon 'bara_[i].png'
        spritePath: 'placeholders/placeholder_square.png',
        size: Vector2(barWidth, barHeight - i * 10),
        position: Vector2(x + barWidth/2, y + (barHeight - i * 10)/2),
        onPlayed: _onBarPlayed,
      ));
    }

    _score = TextComponent(
      text: 'Scor: 0  |  Combo: 0',
      position: Vector2(30, 30),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
    );
    add(_score);

    _prompt = TextComponent(
      text: 'Urmează ritmul: 1 2 3 4 | 5 6 7 8',
      position: Vector2(540, 120),
      anchor: Anchor.topCenter,
      textRenderer: TextPaint(style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w600)),
    );
    add(_prompt);

    _beatBar = RectComponent(
      position: Vector2(90, 170),
      size: Vector2(900, 14),
      paint: Paint()..color = const Color(0xFFFFFFFF).withOpacity(0.25),
      anchor: Anchor.topLeft,
    );
    add(_beatBar);

    _conductor = RhythmConductor(
      bpm: 92,
      sequence: ['B1','B2','B3','B4','B5','B6','B7','B8'],
      onStepChanged: (idx, key) {
        _prompt.add(SequenceEffect([
          ScaleEffect.to(Vector2.all(1.06), EffectController(duration: 0.08, curve: Curves.easeOut)),
          ScaleEffect.to(Vector2.all(1.00), EffectController(duration: 0.12, curve: Curves.easeIn)),
        ]));
      },
      onGoodHit: (key) {
        feedback.hitGood();
        _updateHud();
      },
      onMiss: (exp) {
        feedback.miss();
        _updateHud();
      
      // recompense
      await getIt<ProfileService>().addStars(1);
      await getIt<ProfileService>().unlockRandomSticker();
    },
    );
    add(_conductor);
    _conductor.start();
  }

  void _updateHud() {
    _score.text = 'Scor: ${feedback.score}  |  Combo: ${feedback.combo}';
  }

  void _onBarPlayed(String semanticKey, String label) {
    getIt<AudioService>().playKey(semanticKey);
    _conductor.registerHit(label.replaceAll('B','')); // expected: '1'..'8'
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (children.contains(_beatBar)) {
      final phase = _conductor.phase;
      final front = children.query<RectComponent>().firstWhere(
        (c) => c.priority == 999,
        orElse: () {
          final r = RectComponent(
            priority: 999,
            position: _beatBar.position,
            size: Vector2(0, _beatBar.size.y),
            anchor: Anchor.topLeft,
            paint: Paint()..color = const Color(0xFFFFFFFF),
          );
          add(r);
          return r;
        },
      );
      front.position = _beatBar.position;
      front.size = Vector2(_beatBar.size.x * phase, _beatBar.size.y);
    }
  }
}

class _XyloBar extends SpriteComponent with TapCallbacks, HasGameRef<XylophoneGame> {
  final String label;
  final String semanticKey;
  final void Function(String semanticKey, String label) onPlayed;

  _XyloBar({
    required this.label,
    required this.semanticKey,
    required String spritePath,
    required this.onPlayed,
    super.size,
    super.position,
  }) {
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
    add(ScaleEffect.to(Vector2(0.98, 0.92), EffectController(duration: 0.06, curve: Curves.easeOut)));
  }

  @override
  void onTapUp(TapUpEvent event) {
    add(ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.12, curve: Curves.easeOutBack)));
    _burstEffect();
    onPlayed(semanticKey, label);
  }

  void _burstEffect() {
    final rnd = Random();
    final particle = ParticleSystemComponent(
      particle: Particle.generate(
        count: 24,
        lifespan: 0.5,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, 650),
          speed: Vector2((rnd.nextDouble()-0.5)*260, -rnd.nextDouble()*320),
          position: center.clone(),
          child: CircleParticle(radius: 1.5 + rnd.nextDouble()*2.5, paint: Paint()..color = const Color(0xFF26A69A)),
        ),
      ),
    );
    game.add(particle);
  }
}

// === Overlay API ===
ValueListenable<RhythmState> get coachState => coach.state;
ValueListenable<int> get beatListenable => coach.beat;
void startCoach() { zanaAnimation.value = 'dance_slow'; coach.start(); }
void stopCoach()  { zanaAnimation.value = 'idle'; coach.stop(); }
void tempoUp()    { coach.setTempo(coach.bpm + 5); }
void tempoDown()  { coach.setTempo(coach.bpm - 5); }
void toggleMetronome() { coach.toggleMetronome(); }
// Record controls
void startRec() { coach.startRecording(); }
void stopRec()  async { final seq = coach.stopRecording(); await getIt<ProfileService>().setRecording(seq); }
void playRec()  { coach.playRecording(); }
void clearRec() async { coach.clearRecording(); await getIt<ProfileService>().clearRecording(); }
