import 'dart:math';
import 'package:flutter/foundation.dart';

enum SeqState { idle, preview, input, success, fail }

typedef HighlightFn = Future<void> Function(int index);
typedef OnState = void Function(SeqState state);

/// Motor generic pentru joc "Simon Says" / secvențe ritmice.
class SequenceEngine {
  final int itemCount;
  final HighlightFn highlight;
  final OnState? onState;

  final List<int> _sequence = [];
  final List<int> _buffer = [];
  int level = 0;
  int get length => _sequence.length;
  SeqState state = SeqState.idle;

  final Random _rnd = Random();

  SequenceEngine({required this.itemCount, required this.highlight, this.onState});

  Future<void> start() async {
    level = 1;
    _sequence.clear();
    _buffer.clear();
    await _growAndPreview();
  }

  Future<void> _growAndPreview() async {
    state = SeqState.preview;
    onState?.call(state);
    _sequence.add(_rnd.nextInt(itemCount));
    await Future<void>.delayed(const Duration(milliseconds: 300));
    for (final idx in _sequence) {
      await highlight(idx);
      await Future<void>.delayed(const Duration(milliseconds: 150));
    }
    _buffer.clear();
    state = SeqState.input;
    onState?.call(state);
  }

  Future<void> onTapIndex(int index) async {
    if (state != SeqState.input) return;
    _buffer.add(index);
    // Verifică incremental
    final i = _buffer.length - 1;
    if (_buffer[i] != _sequence[i]) {
      state = SeqState.fail;
      onState?.call(state);
      return;
    }
    if (_buffer.length == _sequence.length) {
      state = SeqState.success;
      onState?.call(state);
    }
  }

  /// Se apelează de joc după ce tratează succesul vizual
  Future<void> nextLevel() async {
    if (state != SeqState.success) return;
    level += 1;
    await _growAndPreview();
  }

  void reset() {
    level = 0;
    _sequence.clear();
    _buffer.clear();
    state = SeqState.idle;
    onState?.call(state);
  }
}
