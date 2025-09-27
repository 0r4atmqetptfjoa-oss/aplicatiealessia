import 'package:alesia/games/shared/base_instrument_game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class PianoGame extends BaseInstrumentGame {
  PianoGame() : super(bpm: 96) {
    primaryColor = const Color(0xFF5E35B1);
  }

  @override
  String get instrumentKey => 'piano';

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewport = FixedResolutionViewport(Vector2(1080, 1920));

    const int keys = 7;
    final notes = <int>[60, 62, 64, 65, 67, 69, 71]; // Do..Si (C4..B4)
    final double margin = 20;
    final double keyWidth = (1080 - margin * (keys + 1)) / keys;
    final double keyHeight = 380;

    for (int i = 0; i < keys; i++) {
      final x = margin + i * (keyWidth + margin);
      final y = 1920 - keyHeight - 80;
      add(_PianoKey(
        label: ['Do','Re','Mi','Fa','Sol','La','Si'][i],
        midi: notes[i],
        // TODO (Răzvan): Înlocuiește sprite-ul placeholder cu o clapă finală 'clapa_[culoare].png'
        spritePath: 'placeholders/placeholder_square.png',
        size: Vector2(keyWidth, keyHeight),
        position: Vector2(x + keyWidth/2, y + keyHeight/2),
      ));
    }
  }
}

class _PianoKey extends SpriteComponent with TapCallbacks, HasGameRef<PianoGame> {
  _PianoKey({
    required this.label,
    required this.midi,
    required String spritePath,
    super.size,
    super.position,
  }) : _spritePath = spritePath {
    anchor = Anchor.center;
  }

  final String label;
  final int midi;
  final String _spritePath;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(_spritePath);
    add(TextComponent(
      text: label,
      anchor: Anchor.center,
      position: Vector2(0, size.y * 0.35),
      textRenderer: TextPaint(style: const TextStyle(fontSize: 36, color: Colors.black, fontWeight: FontWeight.bold)),
    ));
  }

  @override
  void onTapDown(TapDownEvent event) {
    add(ScaleEffect.to(Vector2(0.98, 0.94), EffectController(duration: 0.06, curve: Curves.easeOut)));
  }

  @override
  void onTapUp(TapUpEvent event) {
    add(ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.12, curve: Curves.easeOutBack)));
    game.onPadTriggered(midi: midi, worldPosition: absoluteCenter);
  }
}
