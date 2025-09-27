import 'package:alesia/games/shared/base_instrument_game.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class OrganGame extends BaseInstrumentGame {
  OrganGame() : super(bpm: 88) {
    primaryColor = const Color(0xFF7E57C2);
  }

  @override
  String get instrumentKey => 'organ';

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewport = FixedResolutionViewport(Vector2(1080, 1920));

    const int shells = 5;
    final midis = <int>[60, 62, 64, 65, 67]; // C4..G4
    final double margin = 24;
    final double width = (1080 - margin * (shells + 1)) / shells;
    final double height = 340;
    final double baseY = 1920 - height - 100;

    for (int i = 0; i < shells; i++) {
      final x = margin + i * (width + margin);
      final y = baseY - (i % 2) * 20;
      add(_ShellKey(
        label: 'S${i+1}',
        midi: midis[i],
        // TODO (Răzvan): Înlocuiește sprite-ul placeholder cu clapă-scoică finală 'scoica_[i].png'
        spritePath: 'placeholders/placeholder_square.png',
        size: Vector2(width, height),
        position: Vector2(x + width/2, y + height/2),
      ));
    }
  }
}

class _ShellKey extends SpriteComponent with TapCallbacks, HasGameRef<OrganGame> {
  _ShellKey({required this.label, required this.midi, required String spritePath, super.size, super.position})
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
    game.onPadTriggered(midi: midi, worldPosition: absoluteCenter);
  }
}
