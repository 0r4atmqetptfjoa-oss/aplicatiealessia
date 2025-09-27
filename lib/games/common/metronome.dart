import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/audio_service.dart';

class Metronome {
  final ValueNotifier<int> tick = ValueNotifier(0);
  Timer? _timer;
  int _bpm = 90;

  int get bpm => _bpm;

  void start({int bpm = 90}) {
    _bpm = bpm.clamp(40, 200);
    _timer?.cancel();
    final interval = Duration(milliseconds: (60000 / _bpm).round());
    _timer = Timer.periodic(interval, (_) async {
      tick.value++;
      // TODO (Răzvan): Adaugă 'metronome_click.mp3' în assets/audio/final/
      await getIt<AudioService>().playNote('metronome_click');
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
