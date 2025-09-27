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

class PianoGame extends FlameGame with HasTappables {
  final GameFeedback feedback;
  PianoGame({required this.feedback},
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
    await getIt<AudioService>().preloadNotes(AudioService.defaultPianoMap());

    const int keys = 7;
    final double margin = 20;
    final double keyWidth = (1080 - margin * (keys + 1)) / keys;
    final double keyHeight = 380;

    final labels = ['C4','D4','E4','F4','G4','A4','B4'];
    for (int i = 0; i < keys; i++) {
      final x = margin + i * (keyWidth + margin);
      final y = 1920 - keyHeight - 80;
      final key = _InstrumentPad(
        label: labels[i],
        semanticKey: 'piano:${labels[i]}',
        // TODO (Răzvan): Înlocuiește sprite-ul placeholder cu o clapă finală 'clapa_[culoare].png'
        spritePath: 'placeholders/placeholder_square.png',
        size: Vector2(keyWidth, keyHeight),
        position: Vector2(x + keyWidth/2, y + keyHeight/2),
        onPlayed: _onPadPlayed,
      );
      add(key);
    }

    _score = TextComponent(
      text: 'Scor: 0  |  Combo: 0',
      position: Vector2(30, 30),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
    );
    add(_score);

    _prompt = TextComponent(
      text: 'Urmează ritmul: C4 D4 E4 F4 | G4 A4 B4',
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
      bpm: 96,
      sequence: ['C4','D4','E4','F4','G4','A4','B4'],
      onStepChanged: (idx, key) {
        // subtle pulse in prompt
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

  void _onPadPlayed(String semanticKey, String visualLabel) {
    getIt<AudioService>().playKey(semanticKey);
    _conductor.registerHit(visualLabel);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // progress bar fill based on phase
    if (children.contains(_beatBar)) {
      final phase = _conductor.phase; // 0..1
      (_beatBar.paint)..color = const Color(0xFFFFFFFF).withOpacity(0.25);
      // overlay front bar
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

class _InstrumentPad extends SpriteComponent with TapCallbacks, HasGameRef<PianoGame> {
  final String label;
  final String semanticKey;
  final void Function(String semanticKey, String visualLabel) onPlayed;

  _InstrumentPad({
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
      text: label.replaceAll('4',''),
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
    game.feedback.mood = game.feedback.combo >= 5 ? 'dance_fast' : 'dance_slow';
    _burstEffect();
    onPlayed(semanticKey, label);
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
