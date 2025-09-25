import 'dart:async';
import 'dart:collection';

import 'package:flutter_soloud/flutter_soloud.dart';

/// A singleton service responsible for playing audio samples and notes.
///
/// This service wraps the [`SoLoud`](https://pub.dev/packages/flutter_soloud)
/// instance and caches loaded audio sources to avoid reloading the same
/// asset multiple times.  It exposes convenience methods for playing
/// instrument notes (e.g. piano keys) and arbitrary samples, and allows
/// setting the global volume.
class AudioEngineService {
  AudioEngineService._internal();

  static final AudioEngineService _instance = AudioEngineService._internal();

  /// Access the shared instance of the service.
  factory AudioEngineService() => _instance;

  final SoLoud _soloud = SoLoud.instance;
  final Map<String, AudioSource> _sampleCache = HashMap();
  bool _inited = false;

  /// Initialise the audio engine if it hasn't been initialised yet.
  Future<void> init() async {
    if (_inited) return;
    await _soloud.init();
    _inited = true;
  }

  /// Dispose all loaded samples and deinitialise the engine.
  Future<void> dispose() async {
    for (final src in _sampleCache.values) {
      try {
        await _soloud.disposeSource(src);
      } catch (_) {}
    }
    _sampleCache.clear();
    try {
      _soloud.deinit();
    } catch (_) {}
    _inited = false;
  }

  /// Play a note sample with the given [label] at the provided [volume].
  ///
  /// This assumes you have audio files named like `note_C.wav` in
  /// `assets/audio/notes/`.  The [volume] will be clamped between 0 and 1.
  Future<void> playNote(String label, {double volume = 1.0}) async {
    await playSample('assets/audio/notes/note_$label.wav', volume: volume);
  }

  /// Play an arbitrary audio asset.  The asset will be loaded and cached
  /// on first use, then reused on subsequent calls.  Returns a [SoundHandle]
  /// which can be used to control the playback if needed.
  Future<SoundHandle> playSample(String assetPath, {double volume = 1.0}) async {
    final src = await _getOrLoadAsset(assetPath);
    final handle = await _soloud.play(src, volume: volume.clamp(0.0, 1.0));
    return handle;
  }

  /// Adjust the global volume for all sounds.  [volume] should be between
  /// 0.0 (muted) and 1.0 (full volume).
  Future<void> setMasterVolume(double volume) async {
    _soloud.setGlobalVolume(volume.clamp(0.0, 1.0));
  }

  /// Load an asset from the given path or return the cached source if
  /// already loaded.
  Future<AudioSource> _getOrLoadAsset(String assetPath) async {
    final cached = _sampleCache[assetPath];
    if (cached != null) return cached;
    final src = await _soloud.loadAsset(assetPath);
    _sampleCache[assetPath] = src;
    return src;
  }
}