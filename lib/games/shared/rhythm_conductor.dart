import 'package:flame/components.dart';

typedef StepChanged = void Function(int index, String key);
typedef StepHit = void Function(String key);
typedef StepMiss = void Function(String expectedKey);

/// Drives a simple rhythm game: advances on every beat; expects a key.
class RhythmConductor extends Component with HasGameRef {
  final double bpm;
  final List<String> sequence;
  final double hitWindow; // seconds, half-window around beat center

  final StepChanged? onStepChanged;
  final StepHit? onGoodHit;
  final StepMiss? onMiss;

  RhythmConductor({
    required this.bpm,
    required this.sequence,
    this.hitWindow = 0.18,
    this.onStepChanged,
    this.onGoodHit,
    this.onMiss,
  });

  late final double _period = 60.0 / bpm;
  final Timer _tick = Timer(1, repeat: true);
  int _index = -1;
  double _acc = 0;
  bool _hitThisBeat = false;
  bool _running = false;

  int get stepIndex => _index;
  String get expectedKey => sequence.isEmpty ? '' : sequence[_index % sequence.length];
  double get phase => (_acc % _period) / _period; // 0..1 within beat

  void start() {
    if (_running) return;
    _running = true;
    _acc = 0;
    _index = -1;
    _hitThisBeat = false;
    _tick.stop();
    _tick.limit = _period;
    _tick.onTick = _advance;
    _tick.start();
    // fire first step instantly
    _advance();
  }

  void stop() {
    _running = false;
    _tick.stop();
  }

  void _advance() {
    _index += 1;
    _hitThisBeat = false;
    onStepChanged?.call(_index, expectedKey);
  }

  /// Call from the game when the player taps a key.
  void registerHit(String key) {
    if (!_running || sequence.isEmpty) return;
    final t = _acc % _period;
    final dist = (t - _period/2).abs(); // center of beat
    if (!_hitThisBeat && key == expectedKey && dist <= hitWindow) {
      _hitThisBeat = true;
      onGoodHit?.call(key);
    }
  }

  @override
  void update(double dt) {
    if (!_running) return;
    _acc += dt;
    _tick.update(dt);
    // If we passed the center and no hit yet by the end -> miss
    // We evaluate miss right before advancing, in _advance (on next tick)
    // Here, detect end-of-beat miss edge-case if period drifts; keep it simple.
    if (_tick.finished && !_hitThisBeat) {
      onMiss?.call(expectedKey);
    }
  }
}
