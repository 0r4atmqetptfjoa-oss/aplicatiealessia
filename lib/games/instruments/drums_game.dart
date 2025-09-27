import 'package:alesia/games/shared/base_instrument_game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class DrumsGame extends BaseInstrumentGame {
  DrumsGame() : super(bpm: 100) {
    primaryColor = const Color(0xFFFF6F00);
  }

  @override
  String get instrumentKey => 'drums';

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewport = FixedResolutionViewport(Vector2(1080, 1920));

    final positions = [
      Vector2(360, 740), Vector2(720, 740),
      Vector2(360, 1160), Vector2(720, 1160),
    ];

    final midis = [36, 38, 42, 46]; // Kick, Snare, Closed HH, Open HH

    for (int i = 0; i < positions.length; i++) {
      add(_DrumPad(
        label: ['Kick','Snare','HiHat','OpenHH'][i],
        midi: midis[i],
        // TODO (Răzvan): Înlocuiește sprite-ul placeholder cu un pad final de tobă 'toba_[culoare].png'
        spritePath: 'placeholders/placeholder_square.png',
        position: positions[i],
        size: Vector2(280, 280),
      ));
    }
  }
}

class _DrumPad extends SpriteComponent with TapCallbacks, HasGameRef<DrumsGame> {
  _DrumPad({
    required this.label,
    required this.midi,
    required String spritePath,
    required Vector2 position,
    required Vector2 size,
  }) : _spritePath = spritePath, super(position: position, size: size, anchor: Anchor.center);

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
    add(ScaleEffect.to(Vector2.all(0.9), EffectController(duration: 0.06, curve: Curves.easeOut)));
  }

  @override
  void onTapUp(TapUpEvent event) {
    add(ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.12, curve: Curves.easeOutBack)));
    add(RotateEffect.by(0.1, EffectController(duration: 0.08)));
    game.onPadTriggered(midi: midi, worldPosition: absoluteCenter);
  }
}
