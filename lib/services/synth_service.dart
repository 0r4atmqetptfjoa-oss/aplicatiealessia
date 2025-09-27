import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// Sintetizator simplu pe bază de SoLoud (fără fișiere audio).
/// Generează unde (sine/saw/square/triangle etc.) la frecvențe precise.
class SynthService {
  final SoLoud _soloud = SoLoud.instance;

  /// Cache pentru surse per (waveform, freqKey)
  final Map<String, AudioSource> _sourceCache = HashMap();

  bool _ready = false;

  Future<void> init() async {
    try {
      // Idempotent în practică – dacă e deja inițializat, nu aruncă.
      await _soloud.init();
      _ready = true;
    } catch (e) {
      _ready = false;
      if (kDebugMode) {
        print('SynthService init fallback: $e');
      }
    }
  }

  bool get ready => _ready;

  /// Redă o notă la [hz] folosind [wave].
  /// [duration] controlează durata de menținere înainte de a face fade-out.
  Future<void> playNoteHz(
    double hz, {
    WaveForm wave = WaveForm.sin,
    Duration duration = const Duration(milliseconds: 260),
    double volume = 0.85,
    bool superWave = false,
    double detune = 0.0,
    double scale = 1.0,
  }) async {
    if (!_ready) return;
    final src = await _getOrCreateWave(hz, wave, superWave, scale, detune);
    final handle = await _soloud.play(src, volume: volume);
    // Release: fade-out lin
    unawaited(_soloud.fadeVolume(handle, 0.0, duration));
    // Oprire după fade (best-effort)
    Future.delayed(duration + const Duration(milliseconds: 60), () {
      _soloud.stop(handle);
    });
  }

  Future<AudioSource> _getOrCreateWave(
      double hz, WaveForm wave, bool superWave, double scale, double detune) async {
    final key = '${wave.name}:${hz.toStringAsFixed(2)}:${superWave?1:0}:${scale.toStringAsFixed(2)}:${detune.toStringAsFixed(2)}';
    final cached = _sourceCache[key];
    if (cached != null) return cached;
    final src = await _soloud.loadWaveform(wave, superWave, scale, detune);
    _soloud.setWaveformFreq(src, hz);
    _sourceCache[key] = src;
    return src;
  }
}
