import 'dart:async';

class RecordedEvent {
  final int index;
  final int ms;
  RecordedEvent(this.index, this.ms);
}

class Recorder {
  final List<RecordedEvent> _events = [];
  int? _start;
  bool get isRecording => _start != null;
  bool get hasData => _events.isNotEmpty;

  void start() {
    _events.clear();
    _start = DateTime.now().millisecondsSinceEpoch;
  }

  List<RecordedEvent> stop() {
    final result = List<RecordedEvent>.from(_events);
    _start = null;
    return result;
  }

  void addTap(int index) {
    if (_start == null) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    _events.add(RecordedEvent(index, now - _start!));
  }

  Future<void> playback(Future<void> Function(int index) playAt, void Function(int index, bool on) highlight) async {
    if (_events.isEmpty) return;
    final events = List<RecordedEvent>.from(_events);
    final completer = Completer<void>();
    int i = 0;
    Timer? timer;
    final start = DateTime.now().millisecondsSinceEpoch;
    void schedule() {
      if (i >= events.length) {
        completer.complete();
        return;
      }
      final next = events[i];
      final now = DateTime.now().millisecondsSinceEpoch;
      final delay = (next.ms - (now - start)).clamp(0, 1 << 31);
      timer = Timer(Duration(milliseconds: delay), () async {
        highlight(next.index, true);
        await playAt(next.index);
        Timer(const Duration(milliseconds: 250), () => highlight(next.index, false));
        i++;
        schedule();
      });
    }
    schedule();
    return completer.future;
  }
}
