import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';

/// Interfață simplă pentru un analizor audio pe benzi (FFT).
/// În această fază, folosește un **fallback** bazat pe progresul player-ului.
/// TODO (Răzvan): când motorul audio expune frame-uri PCM sau un API FFT,
/// conectează aici valorile reale.
class AudioAnalyzerService {
  final ValueNotifier<List<double>> bands = ValueNotifier(List<double>.filled(24, 0));
  Timer? _timer;
  bool _running = false;

  bool get supportsRealtime => false; // devine true când conectezi un backend real

  void start(ValueListenable<double> progress) {
    if (_running) return;
    _running = true;
    _timer = Timer.periodic(const Duration(milliseconds: 60), (_) {
      // simulare dinamică pe baza progresului (seed)
      final seed = progress.value;
      final rnd = Random(seed.hashCode ^ DateTime.now().millisecond);
      final out = List<double>.generate(bands.value.length, (i) {
        final base = 0.25 + 0.75 * (0.5 + 0.5 * sin(seed * 8 + i * 0.5));
        final jitter = rnd.nextDouble() * 0.15;
        return (base + jitter).clamp(0.0, 1.0);
      });
      bands.value = out;
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _running = false;
    bands.value = List<double>.filled(bands.value.length, 0);
  }
}
