import 'dart:math';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/audio_service.dart';
import 'package:alesia/services/progress_service.dart';
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

class XylophoneGame extends FlameGame with HasTappables {
  late final SequenceEngine engine;
  late final ZanaController zana;
  late final TextComponent hud;

  final List<_XyloBar> _bars = [];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewport = FixedResolutionViewport(Vector2(1080, 1920));

    hud = TextComponent(
      text: 'Nivel 0',
      position: Vector2(30, 30),
      anchor: Anchor.topLeft,
      priority: 1000,
      textRenderer: TextPaint(style: const TextStyle(fontSize: 28, color: Colors.black87, fontWeight: FontWeight.bold)),
    );
    add(hud);

    zana = ZanaController();
    final zComp = await zana.load(size: Vector2(180, 180));
    zComp.position = Vector2(1080 - 200, 120);
    zComp.anchor = Anchor.topRight;
    add(zComp);

    const int bars = 8;
    final double margin = 20;
    final double barWidth = (1080 - margin * (bars + 1)) / bars;
    final double barHeight = 300;

    final notes = ['C4','D4','E4','F4','G4','A4','B4','C5'];

    for (int i = 0; i < bars; i++) {
      final x = margin + i * (barWidth + margin);
      final y = 1920 - barHeight - 120;
      add(_XyloBar(
        index: i,
        label: 'B${i+1}',
        // TODO (Răzvan): Înlocuiește sprite-ul placeholder cu bara finală de xilofon 'bara_[i].png'
        spritePath: 'placeholders/placeholder_square.png',
        size: Vector2(barWidth, barHeight - i * 10),
        position: Vector2(x + barWidth/2, y + (barHeight - i * 10)/2),
        onTapLogic: () {
          final hz = mt.noteHz(notes[i]);
          getIt<SynthService>().playNoteHz(hz, wave: WaveForm.triangle, superWave: true, detune: 0.04, scale: 1.6, duration: const Duration(milliseconds: 280));
          engine.onTapIndex(i);
          zana.danceSlow();
        },
      ));
    }

    // Collect bars from children
    for (final c in children.whereType<_XyloBar>()) {
      _bars.add(c);
    }

    engine = SequenceEngine(
      itemCount: _bars.length,
      highlight: (idx) async {
        await _bars[idx].flash();
        final hz = mt.noteHz(notes[idx]);
        await getIt<SynthService>().playNoteHz(hz, wave: WaveForm.triangle, superWave: true, detune: 0.05, scale: 1.6, duration: const Duration(milliseconds: 220));
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

    final start = _HudButton('Start', Vector2(540, 140), onPressed: () => engine.start());
    add(start);
  }

  void _shakeAll() {
    for (final p in _bars) {
      p.add(SequenceEffect([
        MoveByEffect(Vector2(14, 0), EffectController(duration: 0.05)),
        MoveByEffect(Vector2(-28, 0), EffectController(duration: 0.08)),
        MoveByEffect(Vector2(14, 0), EffectController(duration: 0.05)),
      ]));
    }
  }

  // Hook apelat de paduri pentru record
  void onUserTapRaw(int index) {
    recorder.addTap(index);
  }
}

class _XyloBar extends SpriteComponent with TapCallbacks, HasGameRef<XylophoneGame> {
  final int index;
  final String label;
  final VoidCallback onTapLogic;
  _XyloBar({required this.index, required this.label, required String spritePath, required this.onTapLogic, super.size, super.position}) {
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

  Future<void> flash() async {
    await add(ScaleEffect.to(Vector2(0.98, 0.92), EffectController(duration: 0.06, curve: Curves.easeOut)));
    await add(ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.12, curve: Curves.easeOutBack)));
    Juicy.burst(game, center, color: const Color(0xFF26A69A), count: 18);
  }

  @override
  void onTapDown(TapDownEvent event) {
    add(ScaleEffect.to(Vector2(0.98, 0.92), EffectController(duration: 0.06, curve: Curves.easeOut)));
  }

  @override
  void onTapUp(TapUpEvent event) {
    add(ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.12, curve: Curves.easeOutBack)));
    getIt<AudioService>().playTap();
    onTapLogic();
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
    final paint = Paint()..color = const Color(0xFFE0F2F1);
    canvas.drawRRect(r, paint);
    final tp = TextPaint(
      style: const TextStyle(fontSize: 24, color: Color(0xFF00695C), fontWeight: FontWeight.bold),
    );
    tp.render(canvas, label, Vector2(size.x / 2 - tp.measureTextWidth(label) / 2, size.y / 2 - 14));
  }

  @override
  void onTapUp(TapUpEvent event) => onPressed();
}
