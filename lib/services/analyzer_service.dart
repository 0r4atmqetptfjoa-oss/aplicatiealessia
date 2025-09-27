import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';

/// AnalyzerService - produce valori tip spectru (0..1) pentru N benzi.
/// În prezent, **simulează** magnitudinile pe baza progresului muzicii.
/// // TODO (Răzvan): Conectează la un PCM tap din engine (flutter_soloud) și înlocuiește semnalul simulat.
class AnalyzerService {
  final int bands;
  final ValueNotifier<List<double>> magnitudes;
  Timer? _timer;
  double _seed = 0;

  AnalyzerService({this.bands = 32}) : magnitudes = ValueNotifier(List<double>.filled(32, 0.0));

  void start(ValueListenable<double> musicProgress) {
    stop();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      _seed = musicProgress.value;
      final rnd = Random((_seed * 10000).floor());
      final m = List<double>.generate(bands, (i) {
        final base = (sin(_seed * 10 + i * 0.4) * 0.5 + 0.5);
        final jitter = 0.15 * rnd.nextDouble();
        final falloff = 1.0 - (i / bands) * 0.5;
        return (base * falloff + jitter).clamp(0.0, 1.0);
      });
      magnitudes.value = m;
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    stop();
    magnitudes.dispose();
  }
}
