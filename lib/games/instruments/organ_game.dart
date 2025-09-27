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

class OrganGame extends FlameGame with HasTappables {
  late final SequenceEngine engine;
  late final ZanaController zana;
  late final TextComponent hud;

  final List<_ShellKey> _keys = [];

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
    final zComp = await zana.load(size: Vector2(200, 200));
    zComp.position = Vector2(1080 - 220, 140);
    zComp.anchor = Anchor.topRight;
    add(zComp);

    const int shells = 5;
    final double margin = 24;
    final double width = (1080 - margin * (shells + 1)) / shells;
    final double height = 340;
    final double baseY = 1920 - height - 100;

    final notes = ['C4','E4','G4','B4','D5'];

    for (int i = 0; i < shells; i++) {
      final x = margin + i * (width + margin);
      final y = baseY - (i % 2) * 20;
      add(_ShellKey(
        index: i,
        label: 'S${i+1}',
        // TODO (Răzvan): Înlocuiește sprite-ul placeholder cu clapă-scoică finală 'scoica_[i].png'
        spritePath: 'placeholders/placeholder_square.png',
        size: Vector2(width, height),
        position: Vector2(x + width/2, y + height/2),
        onTapLogic: () {
          final hz = mt.noteHz(notes[i]);
          getIt<SynthService>().playNoteHz(hz, wave: WaveForm.fsaw, superWave: true, detune: 0.02, scale: 1.2, duration: const Duration(milliseconds: 420));
          engine.onTapIndex(i);
          zana.danceSlow();
        },
      ));
    }

    for (final c in children.whereType<_ShellKey>()) {
      _keys.add(c);
    }

    engine = SequenceEngine(
      itemCount: _keys.length,
      highlight: (idx) async {
        await _keys[idx].flash();
        final hz = mt.noteHz(notes[idx]);
        await getIt<SynthService>().playNoteHz(hz, wave: WaveForm.fsaw, superWave: true, detune: 0.02, scale: 1.2, duration: const Duration(milliseconds: 380));
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
    for (final p in _keys) {
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

class _ShellKey extends SpriteComponent with TapCallbacks, HasGameRef<OrganGame> {
  final int index;
  final String label;
  final VoidCallback onTapLogic;
  _ShellKey({required this.index, required this.label, required String spritePath, required this.onTapLogic, super.size, super.position}) {
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
    await add(SequenceEffect([
      ScaleEffect.to(Vector2(0.96, 0.9), EffectController(duration: 0.06, curve: Curves.easeOut)),
      MoveByEffect(Vector2(0, 6), EffectController(duration: 0.06)),
      ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.12, curve: Curves.easeOutBack)),
      MoveByEffect(Vector2(0, -6), EffectController(duration: 0.12, curve: Curves.easeOutBack)),
    ]));
    Juicy.burst(game, center, color: const Color(0xFF7E57C2), count: 20);
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
    final paint = Paint()..color = const Color(0xFFEDE7F6);
    canvas.drawRRect(r, paint);
    final tp = TextPaint(
      style: const TextStyle(fontSize: 24, color: Color(0xFF5E35B1), fontWeight: FontWeight.bold),
    );
    tp.render(canvas, label, Vector2(size.x / 2 - tp.measureTextWidth(label) / 2, size.y / 2 - 14));
  }

  @override
  void onTapUp(TapUpEvent event) => onPressed();
}
