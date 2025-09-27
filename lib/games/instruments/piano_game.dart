import 'dart:math';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/audio_service.dart';
import 'package:alesia/services/progress_service.dart';
import 'package:alesia/services/quests_service.dart';
import 'package:alesia/services/analytics_service.dart';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/synth_service.dart';
import 'package:alesia/core/music/notes.dart' as mt;
import 'package:alesia/games/common/sequence_engine.dart';
import 'package:alesia/games/common/juicy.dart';
import 'package:alesia/games/common/zana_controller.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class PianoGame extends FlameGame with HasTappables {
  late final SequenceEngine engine;
  late final ZanaController zana;
  late final TextComponent hud;

  final List<_InstrumentPad> _pads = [];

  @override
  Future<void> onLoad() async {
    final a = getIt<AnalyticsService>();
    a.incr('open_piano');
    a.startTimer('time_piano');
    await super.onLoad();
    camera.viewport = FixedResolutionViewport(Vector2(1080, 1920));

    // Hud text
    hud = TextComponent(
      text: 'Nivel 0',
      position: Vector2(30, 30),
      anchor: Anchor.topLeft,
      priority: 1000,
      textRenderer: TextPaint(style: const TextStyle(fontSize: 28, color: Colors.black87, fontWeight: FontWeight.bold)),
    );
    add(hud);

    // Zâna
    zana = ZanaController();
    final zComp = await zana.load(size: Vector2(200, 200));
    zComp.position = Vector2(1080 - 220, 140);
    zComp.anchor = Anchor.topRight;
    add(zComp);

    const int keys = 7;
    final double margin = 20;
    final double keyWidth = (1080 - margin * (keys + 1)) / keys;
    final double keyHeight = 380;

    final notes = ['C4','D4','E4','F4','G4','A4','B4'];

    for (int i = 0; i < keys; i++) {
      final x = margin + i * (keyWidth + margin);
      final y = 1920 - keyHeight - 80;
      final key = _InstrumentPad(
        index: i,
        label: ['Do','Re','Mi','Fa','Sol','La','Si'][i],
        // TODO (Răzvan): Înlocuiește sprite-ul placeholder cu o clapă finală 'clapa_[culoare].png'
        spritePath: 'placeholders/placeholder_square.png',
        size: Vector2(keyWidth, keyHeight),
        position: Vector2(x + keyWidth/2, y + keyHeight/2),
        onTapLogic: () {
          final hz = mt.noteHz(notes[i]);
          getIt<SynthService>().playNoteHz(hz, wave: WaveForm.fsaw, superWave: true, detune: 0.06, scale: 1.8, duration: const Duration(milliseconds: 320));
          engine.onTapIndex(i);
          zana.danceSlow();
        },
      );
      add(key);
      _pads.add(key);
    }

    engine = SequenceEngine(
      itemCount: _pads.length,
      highlight: (idx) async {
        await _pads[idx].flash();
        final hz = mt.noteHz(notes[idx]);
        await getIt<SynthService>().playNoteHz(hz, wave: WaveForm.fsaw, superWave: true, detune: 0.08, scale: 2.0, duration: const Duration(milliseconds: 260));
      },
      onState: (state) {
        hud.text = 'Nivel ${engine.level}  •  Secvență: ${engine.length}';
        if (state == SeqState.success) {
          Juicy.confettiRain(this, streaks: 3);
          zana.danceFast();
          Future.delayed(const Duration(milliseconds: 500), engine.nextLevel);
        } else if (state == SeqState.fail) {
          _shakeAll();
          zana.endingPose();
          Future.delayed(const Duration(milliseconds: 700), engine.start);
        }
      },
    );

    // Start prompt
    final start = _HudButton('Start', Vector2(540, 140), onPressed: () => engine.start());
    add(start);
  }

  void _shakeAll() {
    for (final p in _pads) {
      p.add(SequenceEffect([
        MoveByEffect(Vector2(14, 0), EffectController(duration: 0.05)),
        MoveByEffect(Vector2(-28, 0), EffectController(duration: 0.08)),
        MoveByEffect(Vector2(14, 0), EffectController(duration: 0.05)),
      ]));
    }
  }

  @override
  void onRemove() {
    getIt<AnalyticsService>().stopTimer('time_piano');
    super.onRemove();
  }

  // Hook apelat de paduri pentru record
  void onUserTapRaw(int index) {
    recorder.addTap(index);
  }
}

class _InstrumentPad extends SpriteComponent with TapCallbacks, HasGameRef<PianoGame> {
  final int index;
  final String label;
  final VoidCallback onTapLogic;
  _InstrumentPad({
    required this.index,
    required this.label,
    required this.onTapLogic,
    required String spritePath,
    super.size,
    super.position,
  }) {
    _spritePath = spritePath;
    anchor = Anchor.center;
  }

  late final String _spritePath;

  @override
  Future<void> onLoad() async {
    final a = getIt<AnalyticsService>();
    a.incr('open_piano');
    a.startTimer('time_piano');
    sprite = await Sprite.load(_spritePath);
    add(TextComponent(
      text: label,
      anchor: Anchor.center,
      position: Vector2(0, size.y * 0.35),
      textRenderer: TextPaint(style: const TextStyle(fontSize: 36, color: Colors.black, fontWeight: FontWeight.bold)),
    ));
    add(RoundedRectangleComponent(radius: 22, size: size, paint: Paint()..color = Colors.white.withOpacity(0.0001)));
  }

  Future<void> flash() async {
    await add(ScaleEffect.to(Vector2(0.98, 0.94), EffectController(duration: 0.06, curve: Curves.easeOut)));
    await add(ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.10, curve: Curves.easeOutBack)));
    Juicy.burst(game, center, color: const Color(0xFF673AB7), count: 20);
  }

  @override
  void onTapDown(TapDownEvent event) {
    add(ScaleEffect.to(Vector2(0.98, 0.94), EffectController(duration: 0.06, curve: Curves.easeOut)));
  }

  @override
  void onTapUp(TapUpEvent event) {
    add(ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.12, curve: Curves.easeOutBack)));
    getIt<AudioService>().playTap();
    onTapLogic();
  }

  @override
  void onRemove() {
    getIt<AnalyticsService>().stopTimer('time_piano');
    super.onRemove();
  }

  // Hook apelat de paduri pentru record
  void onUserTapRaw(int index) {
    recorder.addTap(index);
  }
}

class _HudButton extends PositionComponent with TapCallbacks {
  final String label;
  final VoidCallback onPressed;
  _HudButton(this.label, Vector2 pos, {required this.onPressed}) {
    position = pos;
    size = Vector2(200, 64);
    anchor = Anchor.center;
    priority = 1001;
  }

  @override
  void render(Canvas canvas) {
    final r = RRect.fromRectAndRadius(size.toRect(), const Radius.circular(18));
    final paint = Paint()..color = const Color(0xFFEDE7F6);
    canvas.drawRRect(r, paint);
    final tp = TextPaint(
      style: const TextStyle(fontSize: 24, color: Color(0xFF4527A0), fontWeight: FontWeight.bold),
    );
    tp.render(canvas, label, Vector2(size.x / 2 - tp.measureTextWidth(label) / 2, size.y / 2 - 14));
  }

  @override
  void onTapUp(TapUpEvent event) => onPressed();
}
