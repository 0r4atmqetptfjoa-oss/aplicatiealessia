import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart' hide Image;

import '../services/audio_engine_service.dart';

/// A simple interactive map game for exploring sounds.
///
/// The map background displays three zones (farm, jungle, city).  Each
/// zone contains icons that can be tapped to trigger a sound via
/// [AudioEngineService].  Icons animate with a gentle scale effect when
/// activated.
class SoundsGame extends FlameGame {
  SoundsGame();

  final List<_SoundItem> _items = [
    _SoundItem(
      asset: 'sounds/pig.png',
      positionFraction: Vector2(0.15, 0.6),
      soundIndex: 0,
    ),
    _SoundItem(
      asset: 'sounds/cow.png',
      positionFraction: Vector2(0.3, 0.55),
      soundIndex: 1,
    ),
    _SoundItem(
      asset: 'sounds/elephant.png',
      positionFraction: Vector2(0.55, 0.4),
      soundIndex: 2,
    ),
    _SoundItem(
      asset: 'sounds/car.png',
      positionFraction: Vector2(0.8, 0.65),
      soundIndex: 3,
    ),
    _SoundItem(
      asset: 'sounds/sheep.png',
      positionFraction: Vector2(0.2, 0.7),
      soundIndex: 4,
    ),
    _SoundItem(
      asset: 'sounds/monkey.png',
      positionFraction: Vector2(0.65, 0.35),
      soundIndex: 5,
    ),
  ];

  late AudioEngineService _audioEngine;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await images.load('sounds/map.png');
    // Preload icons
    await images.loadAll(_items.map((e) => e.asset).toList());
    _audioEngine = AudioEngineService();
    await _audioEngine.init();
    // Add map background
    final bg = SpriteComponent()
      ..sprite = await loadSprite('sounds/map.png')
      ..size = size;
    add(bg);
    // Add icons
    for (final item in _items) {
      final sprite = await loadSprite(item.asset);
      final icon = _SoundIcon(
        sprite: sprite,
        positionFraction: item.positionFraction,
        soundIndex: item.soundIndex,
        size: Vector2.all(64),
        onTap: (idx) {
          // Use different audio triggers for each index for variation
          switch (idx % 4) {
            case 0:
              _audioEngine.playPianoKey(0);
              break;
            case 1:
              _audioEngine.playDrum(0);
              break;
            case 2:
              _audioEngine.playXylophone(0);
              break;
            case 3:
              _audioEngine.playOrgan(0);
              break;
          }
        },
      );
      add(icon);
    }
  }
}

/// Helper class storing configuration for each sound icon.
class _SoundItem {
  _SoundItem({
    required this.asset,
    required this.positionFraction,
    required this.soundIndex,
  });
  final String asset;
  final Vector2 positionFraction;
  final int soundIndex;
}

/// Sprite component representing an interactive sound icon.
class _SoundIcon extends SpriteComponent with TapCallbacks, HasGameRef<FlameGame> {
  _SoundIcon({
    required Sprite sprite,
    required this.positionFraction,
    required this.soundIndex,
    required Vector2 size,
    required this.onTap,
  }) : super(sprite: sprite, size: size, anchor: Anchor.center);

  final Vector2 positionFraction;
  final int soundIndex;
  final void Function(int) onTap;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position = Vector2(
      gameRef.size.x * positionFraction.x,
      gameRef.size.y * positionFraction.y,
    );
  }

  @override
  void onTapDown(TapDownEvent event) {
    // Shrink slightly on tap down
    add(ScaleEffect.to(
      Vector2(0.8, 0.8),
      EffectController(duration: 0.1, curve: Curves.easeOut),
    ));
  }

  @override
  void onTapUp(TapUpEvent event) {
    // Bounce back and trigger sound
    add(ScaleEffect.to(
      Vector2(1.2, 1.2),
      EffectController(duration: 0.2, reverseDuration: 0.2, curve: Curves.easeOutBack),
      onComplete: () {
        scale = Vector2.all(1);
        onTap(soundIndex);
      },
    ));
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    add(ScaleEffect.to(
      Vector2(1, 1),
      EffectController(duration: 0.1, curve: Curves.easeOut),
    ));
  }
}