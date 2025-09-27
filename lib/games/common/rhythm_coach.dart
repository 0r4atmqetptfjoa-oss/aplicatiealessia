import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:alesia/widgets/rhythm_overlay.dart';

typedef HighlightFn = void Function(int index, bool on);
typedef PlayIndexFn = Future<void> Function(int index);
typedef CelebrateFn = void Function();

class RhythmCoach {
  RhythmCoach({
    required this.count,
    required this.highlight,
    required this.playAt,
    required this.celebrate,
  }) : state = ValueNotifier(const RhythmState(
          phase: RhythmPhase.idle, progress: 0, length: 0, streak: 0, message: 'Idle',
        ));

  final int count;
  final HighlightFn highlight;
  final PlayIndexFn playAt;
  final CelebrateFn celebrate;
  final ValueNotifier<RhythmState> state;

  final _rnd = Random();
  final List<int> _pattern = [];
  final List<Timer> _timers = [];
  int _userPos = 0;
  int _streak = 0;

  void dispose() {
    stop();
    state.dispose();
  }

  void _emit(RhythmPhase p, int progress, int length, String message) {
    state.value = RhythmState(phase: p, progress: progress, length: length, streak: _streak, message: message);
  }

  void start() {
    stop();
    final minLen = 4;
    final maxLen = 8;
    final len = (minLen + (_streak ~/ 2)).clamp(minLen, maxLen);
    final baseMs = 600;
    final tempoMs = (baseMs - (_streak * 20)).clamp(380, 700);
    _pattern
      ..clear()
      ..addAll(List.generate(len, (_) => _rnd.nextInt(count)));
    _userPos = 0;
    _emit(RhythmPhase.demo, 0, _pattern.length, 'Ascultă modelul');
    var delay = 0;
    for (var i = 0; i < _pattern.length; i++) {
      final idx = _pattern[i];
      _timers.add(Timer(Duration(milliseconds: delay), () async {
        highlight(idx, true);
        await playAt(idx);
      }));
      _timers.add(Timer(Duration(milliseconds: delay + (tempoMs ~/ 2)), () {
        highlight(idx, false);
        _emit(RhythmPhase.demo, i + 1, _pattern.length, 'Ascultă modelul');
      }));
      delay += tempoMs;
    }
    _timers.add(Timer(Duration(milliseconds: delay + 100), () {
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
    // redă întotdeauna la tap
    await playAt(index);
    if (state.value.phase != RhythmPhase.user) return;
    final expected = _pattern[_userPos];
    if (index == expected) {
      _userPos++;
      _emit(RhythmPhase.user, _userPos, _pattern.length, 'Bine! Continuă');
      if (_userPos >= _pattern.length) {
        _streak++;
        _emit(RhythmPhase.success, _userPos, _pattern.length, 'Bravo!');
        celebrate();
        // reîncepem automat
        _timers.add(Timer(const Duration(milliseconds: 900), start));
      }
    } else {
      _streak = 0;
      _emit(RhythmPhase.fail, _userPos, _pattern.length, 'Ups! Hai din nou');
      _timers.add(Timer(const Duration(milliseconds: 900), start));
    }
  }
}
