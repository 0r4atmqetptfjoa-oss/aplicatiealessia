import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

class AudioService {
  final SoLoud _soLoud = SoLoud.instance;
  bool _initialized = false;

  /// Cache of loaded AudioSources by asset path.
  final Map<String, AudioSource> _sources = {};

  Future<void> init() async {
    if (_initialized) return;
    try {
      await _soLoud.init();
      _initialized = true;
    } catch (e) {
      if (kDebugMode) {
        // On desktop w/o proper audio device, init can fail; keep app running.
        print('SoLoud init failed: $e');
      }
    }
  }

  Future<AudioSource?> loadSound(String assetPath) async {
    if (!_initialized) await init();
    if (_sources.containsKey(assetPath)) return _sources[assetPath];
    try {
      final src = await _soLoud.loadAsset(assetPath);
      _sources[assetPath] = src;
      return src;
    } catch (e) {
      if (kDebugMode) print('Failed to load sound $assetPath: $e');
      return null;
    }
  }

  Future<void> play(String assetPath, {double volume = 1.0, double pan = 0}) async {
    if (!_initialized) await init();
    final src = await loadSound(assetPath);
    if (src == null) return;
    await _soLoud.play(src, volume: volume, pan: pan);
  }

  Future<void> setGlobalVolume(double volume) async {
    if (!_initialized) await init();
    await _soLoud.setGlobalVolume(volume.clamp(0.0, 1.0));
  }

  Future<void> stopAll() async {
    if (!_initialized) return;
    await _soLoud.stopAll();
  }

  Future<void> dispose() async {
    if (!_initialized) return;
    try {
      await _soLoud.deinit();
    } catch (_) {}
    _initialized = false;
    _sources.clear();
  }
}
