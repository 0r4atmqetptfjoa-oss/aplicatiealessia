import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:alesia/widgets/rhythm_overlay.dart';

typedef HighlightFn = void Function(int index, bool on);
typedef PlayIndexFn = Future<void> Function(int index);
typedef CelebrateFn = void Function();
typedef TickFn = Future<void> Function();

class RhythmCoach {
  RhythmCoach({
    required this.count,
    required this.highlight,
    required this.playAt,
    required this.celebrate,
    this.onTick,
  }) : state = ValueNotifier(const RhythmState(
          phase: RhythmPhase.idle, progress: 0, length: 0, streak: 0, message: 'Idle', bpm: 90, metronomeOn: false),
       ),
       beat = ValueNotifier<int>(0);

  final int count;
  final HighlightFn highlight;
  final PlayIndexFn playAt;
  final CelebrateFn celebrate;
  final TickFn? onTick;
  final ValueNotifier<RhythmState> state;
  final ValueNotifier<int> beat;

  final _rnd = Random();
  final List<int> _pattern = [];
  final List<Timer> _timers = [];
  int _userPos = 0;
  int _streak = 0;
  int _bpm = 90;
  bool _metronome = false;

  // recording
  final List<int> _recording = [];
  bool _isRecording = false;

  int get bpm => _bpm;
  bool get metronomeOn => _metronome;
  bool get isRecording => _isRecording;

  void dispose() {
    stop();
    state.dispose();
    beat.dispose();
  }

  void _emit(RhythmPhase p, int progress, int length, String message) {
    state.value = RhythmState(phase: p, progress: progress, length: length, streak: _streak, message: message, bpm: _bpm, metronomeOn: _metronome);
  }

  void setTempo(int bpm) {
    _bpm = bpm.clamp(60, 160);
    _emit(state.value.phase, state.value.progress, state.value.length, state.value.message);
  }

  void toggleMetronome() {
    _metronome = !_metronome;
    _emit(state.value.phase, state.value.progress, state.value.length, state.value.message);
  }

  void start() {
    stop();
    final length = 4 + min(_streak, 4); // 4..8 pe baza streak-ului
    _pattern
      ..clear()
      ..addAll(List.generate(length, (_) => _rnd.nextInt(count)));
    _userPos = 0;
    _emit(RhythmPhase.demo, 0, _pattern.length, 'Ascultă modelul');
    _scheduleDemo();
  }

  void _scheduleDemo() {
    final stepMs = _stepMs();
    var delay = 0;
    for (var i = 0; i < _pattern.length; i++) {
      final idx = _pattern[i];
      _timers.add(Timer(Duration(milliseconds: delay), () async {
        if (_metronome) _tick();
        highlight(idx, true);
        await playAt(idx);
      }));
      _timers.add(Timer(Duration(milliseconds: delay + (stepMs * 0.55).toInt()), () {
        highlight(idx, false);
        _emit(RhythmPhase.demo, i + 1, _pattern.length, 'Ascultă modelul');
      }));
      delay += stepMs;
    }
    _timers.add(Timer(Duration(milliseconds: delay + 100), () {
      _emit(RhythmPhase.user, 0, _pattern.length, 'Repetă modelul');
      if (_metronome) {
        // pornește tick-uri pe toată faza user cu un timer periodic
        _startMetronomePeriodic();
      }
    }));
  }

  void _startMetronomePeriodic() {
    final ms = _stepMs();
    _timers.add(Timer.periodic(Duration(milliseconds: ms), (_) => _tick()));
  }

  int _stepMs() {
    // aproximăm o bătaie per element
    return (60000 / _bpm).round();
  }

  void stop() {
    for (final t in _timers) {
      t.cancel();
    }
    _timers.clear();
    for (var i = 0; i < count; i++) {
      highlight(i, false);
    }
    _emit(RhythmPhase.idle, 0, 0, 'Idle');
  }

  Future<void> onUserTap(int index) async {
    // redăm sunetul mereu
    await playAt(index);
    if (_isRecording) {
      _recording.add(index);
    }
    final phase = state.value.phase;
    if (phase != RhythmPhase.user) return;
    final expected = _pattern[_userPos];
    if (index == expected) {
      _userPos++;
      _emit(RhythmPhase.user, _userPos, _pattern.length, 'Bine! Continuă');
      if (_userPos >= _pattern.length) {
        _streak++;
        _emit(RhythmPhase.success, _userPos, _pattern.length, 'Bravo!');
        celebrate();
        // tempo crește treptat odată cu streak-ul
        setTempo(90 + min(_streak, 8) * 5);
        _timers.add(Timer(const Duration(milliseconds: 900), start));
      }
    } else {
      _streak = 0;
      setTempo(90);
      _emit(RhythmPhase.fail, _userPos, _pattern.length, 'Ups! Hai din nou');
      _timers.add(Timer(const Duration(milliseconds: 900), start));
    }
  }

  void _tick() {
    beat.value = beat.value + 1;
    if (onTick != null) {
      onTick!();
    }
  }

  // Record & playback
  void startRecording() {
    _recording
      ..clear();
    _isRecording = true;
    _emit(state.value.phase, state.value.progress, state.value.length, 'REC...');
  }

  List<int> stopRecording() {
    _isRecording = false;
    _emit(state.value.phase, state.value.progress, state.value.length, 'REC oprit');
    return List<int>.from(_recording);
  }

  void clearRecording() {
    _recording.clear();
  }

  void playRecording() {
    if (_recording.isEmpty) return;
    final stepMs = _stepMs();
    var delay = 0;
    for (var i = 0; i < _recording.length; i++) {
      final idx = _recording[i];
      _timers.add(Timer(Duration(milliseconds: delay), () async {
        highlight(idx, true);
        await playAt(idx);
      }));
      _timers.add(Timer(Duration(milliseconds: delay + (stepMs * 0.55).toInt()), () {
        highlight(idx, false);
      }));
      delay += stepMs;
    }
  }
}
