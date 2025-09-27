import 'package:alesia/games/shared/base_instrument_game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class XylophoneGame extends BaseInstrumentGame {
  XylophoneGame() : super(bpm: 92) {
    primaryColor = const Color(0xFF26A69A);
  }

  @override
  String get instrumentKey => 'xylophone';

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewport = FixedResolutionViewport(Vector2(1080, 1920));

    const int bars = 8;
    final midis = <int>[72, 74, 76, 77, 79, 81, 83, 84]; // C5..C6 major
    final double margin = 20;
    final double barWidth = (1080 - margin * (bars + 1)) / bars;
    final double barHeight = 300;

    for (int i = 0; i < bars; i++) {
      final x = margin + i * (barWidth + margin);
      final y = 1920 - barHeight - 120;
      add(_XyloBar(
        label: 'B${i+1}',
        midi: midis[i],
        // TODO (Răzvan): Înlocuiește sprite-ul placeholder cu bara finală de xilofon 'bara_[i].png'
        spritePath: 'placeholders/placeholder_square.png',
        size: Vector2(barWidth, barHeight - i * 10),
        position: Vector2(x + barWidth/2, y + (barHeight - i * 10)/2),
      ));
    }
  }
}

class _XyloBar extends SpriteComponent with TapCallbacks, HasGameRef<XylophoneGame> {
  _XyloBar({required this.label, required this.midi, required String spritePath, super.size, super.position})
      : _spritePath = spritePath {
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
    game.onPadTriggered(midi: midi, worldPosition: absoluteCenter);
  }
}
