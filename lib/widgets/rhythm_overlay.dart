import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

/// Original controls widget kept for backwards-compatibility with screens.
class RhythmOverlay extends StatelessWidget {
  final ValueListenable<String> stateListenable;
  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onToggleRecord;
  final VoidCallback onPlayRecording;
  final ValueChanged<int> onTempoChange;
  final VoidCallback onMetronomeToggle;
  final ValueListenable<int> beatListenable;
  final ValueListenable<int> bpmListenable;
  final ValueListenable<bool> recordingListenable;
  final ValueListenable<bool> hasRecordingListenable;
  final ValueListenable<bool> metronomeOnListenable;

  const RhythmOverlay({
    super.key,
    required this.stateListenable,
    required this.onStart,
    required this.onStop,
    required this.onToggleRecord,
    required this.onPlayRecording,
    required this.onTempoChange,
    required this.onMetronomeToggle,
    required this.beatListenable,
    required this.bpmListenable,
    required this.recordingListenable,
    required this.hasRecordingListenable,
    required this.metronomeOnListenable,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Mini joc de ritm (demo)'), const SizedBox(height: 8),
                SizedBox(
                  height: 140, child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: GameWidget(game: RhythmGame.demo()),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: metronomeOnListenable,
                      builder: (_, on, __) => IconButton(
                        onPressed: onMetronomeToggle,
                        icon: Icon(on ? Icons.music_note : Icons.music_off),
                        tooltip: 'Metronom',
                      ),
                    ),
                    const SizedBox(width: 8),
                    ValueListenableBuilder<int>(
                      valueListenable: beatListenable,
                      builder: (_, beat, __) => Text('Beat ${beat+1}/4'),
                    ),
                    const SizedBox(width: 12),
                    ValueListenableBuilder<int>(
                      valueListenable: bpmListenable,
                      builder: (_, bpm, __) => Row(
                        children: [
                          Text('BPM $bpm'),
                          Slider(
                            value: bpm.toDouble(),
                            min: 40, max: 220,
                            onChanged: (v) => onTempoChange(v.round()),
                            divisions: 180,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(onPressed: onStart, child: const Text('Start')),
                    const SizedBox(width: 6),
                    ElevatedButton(onPressed: onStop, child: const Text('Stop')),
                    const SizedBox(width: 12),
                    ValueListenableBuilder<bool>(
                      valueListenable: recordingListenable,
                      builder: (_, rec, __) => ElevatedButton.icon(
                        onPressed: onToggleRecord,
                        icon: Icon(rec ? Icons.stop : Icons.fiber_manual_record),
                        label: Text(rec ? 'Stop rec' : 'Rec'),
                      ),
                    ),
                    const SizedBox(width: 6),
                    ValueListenableBuilder<bool>(
                      valueListenable: hasRecordingListenable,
                      builder: (_, has, __) => ElevatedButton.icon(
                        onPressed: has ? onPlayRecording : null,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Play'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ==== Rhythm Mini-Game (Flame) ====

class BeatEvent {
  final int timestampMs;
  final int lane;
  BeatEvent(this.timestampMs, this.lane);
}

class BeatMap {
  final List<BeatEvent> events;
  BeatMap(this.events);

  static BeatMap demo() {
    // Simple fixed pattern: lanes 0..3 every 350ms
    final ev = <BeatEvent>[];
    int t = 400;
    for (int i = 0; i < 12; i++) {
      ev.add(BeatEvent(t, i % 4));
      t += 350;
    }
    return BeatMap(ev);
  }
}

class FallingNote extends PositionComponent {
  final int lane;
  final double speed; // px/s
  FallingNote({required this.lane, required this.speed}) {
    size = Vector2(24, 24);
  }

  @override
  void render(Canvas canvas) {
    final r = RRect.fromRectAndRadius(size.toRect(), const Radius.circular(6));
    final p = Paint()..color = Colors.deepPurpleAccent;
    canvas.drawRRect(r, p);
  }

  @override
  void update(double dt) {
    position.y += speed * dt;
    if (position.y > (parent?.size.y ?? 0) + 40) {
      removeFromParent();
    }
  }
}

class HitBar extends PositionComponent {
  @override
  void render(Canvas canvas) {
    final p = Paint()..color = Colors.black.withOpacity(0.2);
    final r = Rect.fromLTWH(0, 0, size.x, 8);
    canvas.drawRect(r, p);
  }
}

class RhythmGame extends FlameGame with TapCallbacks {
  RhythmGame(this.map);
  final BeatMap map;

  // pseudo clock (we don't integrate a full audio player here to keep it self-contained)
  double elapsedMs = 0;
  int nextIndex = 0;
  final lanes = 4;
  late HitBar hitBar;
  int score = 0;

  RhythmGame.demo() : map = BeatMap.demo();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewport = FixedResolutionViewport(Vector2(260, 120));
    // Hit bar near bottom
    hitBar = HitBar()..size = Vector2(size.x, 8)..position = Vector2(0, size.y - 24);
    add(hitBar);
  }

  @override
  void update(double dt) {
    super.update(dt);
    elapsedMs += dt * 1000.0;
    // Spawn notes when time arrives
    while (nextIndex < map.events.length && elapsedMs >= map.events[nextIndex].timestampMs - 600) {
      final e = map.events[nextIndex++];
      _spawn(e);
    }
  }

  void _spawn(BeatEvent e) {
    final laneWidth = size.x / lanes;
    final x = e.lane * laneWidth + laneWidth / 2 - 12;
    final n = FallingNote(lane: e.lane, speed: 200)..position = Vector2(x, -24);
    add(n);
  }

  @override
  void onTapDown(TapDownEvent event) {
    final local = event.localPosition;
    final laneWidth = size.x / lanes;
    final lane = (local.x / laneWidth).floor().clamp(0, lanes - 1);
    // Find closest note in lane in hit window (near hitBar.y)
    final yTarget = hitBar.position.y;
    const window = 16.0;
    final notes = children.whereType<FallingNote>().where((n) => n.lane == lane).toList();
    FallingNote? hit;
    double best = double.infinity;
    for (final n in notes) {
      final d = (n.position.y - yTarget).abs();
      if (d < window && d < best) {
        best = d;
        hit = n;
      }
    }
    if (hit != null) {
      hit.removeFromParent();
      score += math.max(0, ((window - best) / window * 100).round());
    }
  }
}
