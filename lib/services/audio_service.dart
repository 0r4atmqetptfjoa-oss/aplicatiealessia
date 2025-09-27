import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

class AudioService {
  final SoLoud _soloud = SoLoud.instance;
  final Map<String, AudioSource> _cache = {};
  AudioSource? _tap;
  bool _ready = false;
  int? _bgmCurrent;
  int? _bgmNext;

  Future<void> init() async {
    try {
      await _soloud.init();
      // TODO (Răzvan): Înlocuiește cu sunetul final, ex: 'assets/audio/final/tap.mp3'
      _tap = await _soloud.loadAsset('assets/audio/placeholders/placeholder_sound.mp3');
      _ready = true;
    } catch (e) {
      _ready = false;
      if (kDebugMode) {
        // În modul placeholder (fără fișier audio real), ignorăm erorile.
        print('AudioService init fallback: $e');
      }
    }
  }

  /// Redă o notă după instrument și midi number (ex: 60 = C4).
  /// Calea implicită a resursei finale: assets/audio/final/<instrument>/<midi>.mp3
  Future<void> playNote({required String instrument, required int midi}) async {
    if (!_ready) return;
    final key = 'assets/audio/final/$instrument/$midi.mp3';
    try {
      final src = _cache[key] ??= await _soloud.loadAsset(key);
      await _soloud.play(src);
    } catch (e) {
      // Fallback la click generic (placeholder).
      if (_tap != null) {
        try { await _soloud.play(_tap!); } catch (_) {}
      }
      if (kDebugMode) {
        print('playNote fallback for $key: $e');
      }
    }
  }

  Future<void> playTap() async {
    if (_ready && _tap != null) {
      try {
        await _soloud.play(_tap!);
      } catch (_) {
        // no-op
      }
    }
  }

  Future<void> dispose() async {
    try {
      await _soloud.deinit();
    } catch (_) {}
  }
}

  Future<void> playMusic(String id, {int fadeMs = 800}) async {
    if (!_ready) return;
    final src = await _load('assets/audio/final/' + id + '.mp3');
    if (src == null) return;
    try {
      _bgmNext = await _soloud.play(src, volume: 0);
      final steps = 8;
      for (int i = 1; i <= steps; i++) {
        final vNext = i / steps;
        final vCur = 1 - vNext;
        if (_bgmNext != null) await _soloud.setVolume(_bgmNext!, vNext);
        if (_bgmCurrent != null) await _soloud.setVolume(_bgmCurrent!, vCur);
        await Future.delayed(Duration(milliseconds: (fadeMs / steps).round()));
      }
      if (_bgmCurrent != null) await _soloud.stop(_bgmCurrent!);
      _bgmCurrent = _bgmNext;
      _bgmNext = null;
    } catch (_) {}
  }

  Future<void> stopMusic() async {
    if (_bgmCurrent != null) {
      try { await _soloud.stop(_bgmCurrent!); } catch (_) {}
      _bgmCurrent = null;
    }
  }
