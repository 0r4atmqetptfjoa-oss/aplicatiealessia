import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

class AudioService {
  final SoLoud _soloud = SoLoud.instance;
  final Map<String, AudioSource> _cache = {};
  AudioSource? _tap;
  AudioSource? _bg;
  bool _ready = false;

  Future<void> init() async {
    try {
      await _soloud.init(bufferSize: 1024);
    SoLoud.instance.setVisualizationEnabled(true);
    SoLoud.instance.setFftSmoothing(0.7);
      // TODO (Răzvan): Înlocuiește cu sunetul final, ex: 'assets/audio/final/tap.mp3'
      _tap = await _load('assets/audio/placeholders/placeholder_sound.mp3');
      // TODO (Răzvan): Poți adăuga un fundal în 'assets/audio/final/bg_music.mp3'
      _bg = await _load('assets/audio/final/bg_music.mp3');
      _ready = true;
    } catch (e) {
      _ready = false;
      if (kDebugMode) {
        print('AudioService init fallback: $e');
      }
    }
  }

  Future<AudioSource?> _load(String path) async {
    try {
      return await _soloud.loadAsset(path);
    } catch (e) {
      if (kDebugMode) {
        print('Audio load failed for $path: $e');
      }
      return null;
    }
  }

  Future<void> playTap() async {
    if (!_ready) return;
    if (_tap != null) {
      try { await _soloud.play(_tap!); } catch (_) {}
    }
  }

  /// Redă o notă după id (ex: 'piano_do4', 'xylo_c5', 'organ_c4', 'drum_snare', 'tick').
  /// Va încerca `assets/audio/final/<id>.mp3`. Dacă nu există, folosește `playTap()` ca fallback.
  Future<void> playNote(String id) async {
    if (!_ready) return;
    var src = _cache[id];
    if (src == null) {
      // TODO (Răzvan): Adaugă fișiere reale în `assets/audio/final/` cu denumirea exactă `<id>.mp3`
      src = await _load('assets/audio/final/$id.mp3');
      if (src != null) _cache[id] = src;
    }
    if (src != null) {
      try { await _soloud.play(src); return; } catch (_) {}
    }
    await playTap(); // fallback silențios
  }

  /// Tick metronom (folosește 'tick.mp3' dacă există în final/)
  Future<void> playTick() => playNote('tick');

  /// Redă o bucată de fundal (one-shot). Pentru loop, reapelează periodic sau utilizează un fișier lung.
  Future<void> playBackgroundOnce() async {
    if (!_ready || _bg == null) return;
    try { await _soloud.play(_bg!); } catch (_) {}
  }

  Future<void> dispose() async {
    try {
      await _soloud.deinit();
    } catch (_) {}
  }
}
