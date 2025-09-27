import 'dart:async';

class TapEvent {
  final int index;
  final int offsetMs;
  TapEvent(this.index, this.offsetMs);
}

class Recording {
  final List<TapEvent> events;
  final int durationMs;
  Recording(this.events, this.durationMs);
}

class SimpleRecorder {
  bool _recording = false;
  DateTime? _startAt;
  final List<TapEvent> _events = [];
  Recording? last;

  bool get isRecording => _recording;
  bool get hasRecording => last != null;

  void start() {
    _recording = true;
    _events.clear();
    _startAt = DateTime.now();
    last = null;
  }

  void onTap(int index) {
    if (!_recording || _startAt == null) return;
    final ms = DateTime.now().difference(_startAt!).inMilliseconds;
    _events.add(TapEvent(index, ms));
  }

  Recording? stop() {
    if (!_recording || _startAt == null) return null;
    final dur = DateTime.now().difference(_startAt!).inMilliseconds;
    final rec = Recording(List.unmodifiable(_events), dur);
    last = rec;
    _recording = false;
    _startAt = null;
    return rec;
  }

  Future<void> play(Future<void> Function(int index) playAt) async {
    final rec = last;
    if (rec == null) return;
    final completer = Completer<void>();
    int remaining = rec.events.length;
    for (final e in rec.events) {
      Timer(Duration(milliseconds: e.offsetMs), () async {
        await playAt(e.index);
        remaining -= 1;
        if (remaining <= 0 && !completer.isCompleted) {
          completer.complete();
        }
      });
    }
    return completer.future;
  }
}
