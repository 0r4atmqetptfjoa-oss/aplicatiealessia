import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';

/// Minimal shared base for instrument games to keep screens compiling.
abstract class BaseInstrumentGame extends FlameGame {
  BaseInstrumentGame({required this.instrumentId});
  final String instrumentId;

  // Simple coaching/recording/metronome stand-ins used by UI.
  final coach = _CoachState();
  final recorder = _RecorderState();
  final conductor = _ConductorState();
  final metronome = _MetronomeState();
}

class _CoachState {
  final ValueNotifier<String> state = ValueNotifier<String>('idle');
  void start() => state.value = 'playing';
  void stop() => state.value = 'stopped';
}

class _RecorderState {
  final ValueNotifier<bool> isRecording = ValueNotifier<bool>(false);
  final ValueNotifier<bool> hasRecording = ValueNotifier<bool>(false);
  void toggle() { isRecording.value = !isRecording.value; if (!isRecording.value) hasRecording.value = true; }
  void play() {}
}

class _ConductorState {
  final ValueNotifier<int> beat = ValueNotifier<int>(0);
  final ValueNotifier<int> bpm = ValueNotifier<int>(100);
  void setBpm(int v) => bpm.value = v;
}

class _MetronomeState {
  final ValueNotifier<bool> isOn = ValueNotifier<bool>(false);
  void toggle() => isOn.value = !isOn.value;
}
