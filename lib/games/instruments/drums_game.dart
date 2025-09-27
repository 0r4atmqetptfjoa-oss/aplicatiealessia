import 'dart:math';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/audio_service.dart';
import 'package:alesia/services/progress_service.dart';
import 'package:alesia/services/synth_service.dart';
import 'package:alesia/games/common/sequence_engine.dart';
import 'package:alesia/games/common/juicy.dart';
import 'package:alesia/games/common/zana_controller.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class DrumsGame extends FlameGame with HasTappables {
  late final SequenceEngine engine;
  late final ZanaController zana;
  late final TextComponent hud;

  final List<_DrumPad> _pads = [];

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

    final positions = [
      Vector2(360, 780), Vector2(720, 780),
      Vector2(360, 1200), Vector2(720, 1200),
    ];

    // Patru frecvențe percuție (simulate), release scurt
    final freqs = [120.0, 180.0, 220.0, 280.0];

    for (int i = 0; i < positions.length; i++) {
      final pad = _DrumPad(
        index: i,
        label: 'Pad ${i+1}',
        // TODO (Răzvan): Înlocuiește sprite-ul placeholder cu un pad final de tobă 'toba_[culoare].png'
        spritePath: 'placeholders/placeholder_square.png',
        position: positions[i],
        size: Vector2(300, 300),
        onTapLogic: () {
          getIt<SynthService>().playNoteHz(freqs[i], wave: WaveForm.fsquare, superWave: true, scale: 1.5, detune: 0.07, duration: const Duration(milliseconds: 150));
          engine.onTapIndex(i);
          zana.danceSlow();
        },
      );
      add(pad);
      _pads.add(pad);
    }

    engine = SequenceEngine(
      itemCount: _pads.length,
      highlight: (idx) async {
        await _pads[idx].flash();
        await getIt<SynthService>().playNoteHz(freqs[idx], wave: WaveForm.fsquare, superWave: true, scale: 1.6, detune: 0.06, duration: const Duration(milliseconds: 120));
      },
      onState: (state) {
        hud.text = 'Nivel ${engine.level}  •  Secvență: ${engine.length}';
        if (state == SeqState.success) {
          Juicy.confettiRain(this, streaks: 4);
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
    for (final p in _pads) {
      p.add(SequenceEffect([
        MoveByEffect(Vector2(16, 0), EffectController(duration: 0.05)),
        MoveByEffect(Vector2(-32, 0), EffectController(duration: 0.08)),
        MoveByEffect(Vector2(16, 0), EffectController(duration: 0.05)),
      ]));
    }
  }

  // Hook apelat de paduri pentru record
  void onUserTapRaw(int index) {
    recorder.addTap(index);
  }
}

class _DrumPad extends SpriteComponent with TapCallbacks, HasGameRef<DrumsGame> {
  final int index;
  final String label;
  final VoidCallback onTapLogic;
  _DrumPad({
    required this.index,
    required this.label,
    required this.onTapLogic,
    required String spritePath,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, anchor: Anchor.center) {
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

  Future<void> flash() async {
    await add(ScaleEffect.to(Vector2.all(0.9), EffectController(duration: 0.06, curve: Curves.easeOut)));
    await add(ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.12, curve: Curves.easeOutBack)));
    Juicy.burst(game, center, color: const Color(0xFFEF6C00), count: 18);
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
    final paint = Paint()..color = const Color(0xFFFFF3E0);
    canvas.drawRRect(r, paint);
    final tp = TextPaint(
      style: const TextStyle(fontSize: 24, color: Color(0xFFEF6C00), fontWeight: FontWeight.bold),
    );
    tp.render(canvas, label, Vector2(size.x / 2 - tp.measureTextWidth(label) / 2, size.y / 2 - 14));
  }

  @override
  void onTapUp(TapUpEvent event) => onPressed();
}
