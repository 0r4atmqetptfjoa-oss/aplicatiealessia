import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:alesia/widgets/rhythm_overlay.dart';

typedef HighlightFn = void Function(int index, bool on);
typedef PlayIndexFn = Future<void> Function(int index);
typedef CelebrateFn = void Function();
typedef BeatFn = void Function(int beatCount);

class RhythmCoach {
  RhythmCoach({
    required this.count,
    required this.highlight,
    required this.playAt,
    required this.celebrate,
    required this.onBeat,
    this.baseLength = 4,
    this.maxLength = 8,
    this.baseBpm = 96,
    this.maxBpm = 144,
  }) : state = ValueNotifier(const RhythmState(
          phase: RhythmPhase.idle, progress: 0, length: 0, streak: 0, message: 'Idle',
        ));

  final int count;
  final HighlightFn highlight;
  final PlayIndexFn playAt;
  final CelebrateFn celebrate;
  final BeatFn onBeat;
  final int baseLength;
  final int maxLength;
  final int baseBpm;
  final int maxBpm;

  final _rnd = Random();
  final List<int> _pattern = [];
  final List<Timer> _timers = [];
  int _userPos = 0;
  int _streak = 0;
  int _bpm = 96;
  int _beatCounter = 0;

  ValueNotifier<RhythmState> state;

  int get bpm => _bpm;

  void dispose() {
    stop();
    state.dispose();
  }

  void _emit(RhythmPhase p, int progress, int length, String message) {
    state.value = RhythmState(phase: p, progress: progress, length: length, streak: _streak, message: message);
  }

  int _msPerBeat() => (60000 / _bpm).round();

  int _currentLength() => min(maxLength, baseLength + max(0, _streak));

  void setBpm(int bpm) {
    _bpm = bpm.clamp(baseBpm, maxBpm);
  }

  void start() {
    stop();
    _bpm = _bpm == 96 ? baseBpm : _bpm; // dacă e default, pornește de la base
    _pattern
      ..clear()
      ..addAll(List.generate(_currentLength(), (_) => _rnd.nextInt(count)));
    _userPos = 0;
    _emit(RhythmPhase.demo, 0, _pattern.length, 'Ascultă modelul');

    // demo + beat
    var delay = 0;
    for (var i = 0; i < _pattern.length; i++) {
      final idx = _pattern[i];
      _timers.add(Timer(Duration(milliseconds: delay), () async {
        _beatCounter++;
        onBeat(_beatCounter);
        highlight(idx, true);
        await playAt(idx);
      }));
      _timers.add(Timer(Duration(milliseconds: delay + (_msPerBeat() * 0.6).round()), () {
        highlight(idx, false);
        _emit(RhythmPhase.demo, i + 1, _pattern.length, 'Ascultă modelul');
      }));
      delay += _msPerBeat();
    }
    _timers.add(Timer(Duration(milliseconds: delay + 50), () {
      _emit(RhythmPhase.user, 0, _pattern.length, 'Repetă modelul');
    }));
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
    // Permitem redarea liberă a sunetului
    await playAt(index);

    if (state.value.phase != RhythmPhase.user) return;
    _beatCounter++;
    onBeat(_beatCounter);

    final expected = _pattern[_userPos];
    if (index == expected) {
      _userPos++;
      _emit(RhythmPhase.user, _userPos, _pattern.length, 'Bine! Continuă');
      if (_userPos >= _pattern.length) {
        _streak++;
        // crește dificultatea: bpm +4, length +1 (via _currentLength)
        _bpm = (_bpm + 4).clamp(baseBpm, maxBpm);
        _emit(RhythmPhase.success, _userPos, _pattern.length, 'Bravo!');
        celebrate();
        _timers.add(Timer(const Duration(milliseconds: 900), start));
      }
    } else {
      _streak = max(0, _streak - 1);
      _bpm = baseBpm; // reset tempo
      _emit(RhythmPhase.fail, _userPos, _pattern.length, 'Ups! Hai din nou');
      _timers.add(Timer(const Duration(milliseconds: 900), start));
    }
  }
}
