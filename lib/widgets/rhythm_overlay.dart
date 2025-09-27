import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum RhythmPhase { idle, demo, user, success, fail }

class RhythmState {
  final RhythmPhase phase;
  final int progress;
  final int length;
  final int streak;
  final String message;
  const RhythmState({required this.phase, required this.progress, required this.length, required this.streak, required this.message});
}

typedef RhythmStart = void Function();
typedef RhythmStop = void Function();
typedef ToggleRecord = void Function();
typedef PlayRecording = void Function();
typedef TempoChange = void Function(int bpm);
typedef MetronomeToggle = void Function(bool on);

class RhythmOverlay extends StatelessWidget {
  final ValueListenable<RhythmState> stateListenable;
  final RhythmStart onStart;
  final RhythmStop onStop;
  final ToggleRecord onToggleRecord;
  final PlayRecording onPlayRecording;
  final TempoChange onTempoChange;
  final MetronomeToggle onMetronomeToggle;
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

  Color _phaseColor(RhythmPhase p) {
    switch (p) {
      case RhythmPhase.demo: return Colors.blueAccent;
      case RhythmPhase.user: return Colors.deepPurple;
      case RhythmPhase.success: return Colors.green;
      case RhythmPhase.fail: return Colors.redAccent;
      case RhythmPhase.idle: default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Material(
            color: Colors.white.withOpacity(0.95),
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValueListenableBuilder<RhythmState>(
                    valueListenable: stateListenable,
                    builder: (context, state, _) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(width: 10, height: 10, decoration: BoxDecoration(color: _phaseColor(state.phase), shape: BoxShape.circle)),
                          const SizedBox(width: 8),
                          Text(state.message, style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 12),
                          Row(children: List.generate(state.length, (i) {
                            final filled = i < state.progress;
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2),
                              child: Icon(filled ? Icons.circle : Icons.circle_outlined, size: 12),
                            );
                          })),
                          const SizedBox(width: 12),
                          Text('x${state.streak}', style: const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ).animate().fade(duration: 250.ms);
                    },
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(onPressed: onStart, child: const Text('Start')),
                      const SizedBox(width: 6),
                      OutlinedButton(onPressed: onStop, child: const Text('Stop')),
                      const SizedBox(width: 8),
                      ValueListenableBuilder<bool>(
                        valueListenable: recordingListenable,
                        builder: (context, rec, _) {
                          return ElevatedButton.icon(
                            onPressed: onToggleRecord,
                            icon: Icon(rec ? Icons.stop_circle : Icons.fiber_manual_record, color: rec ? Colors.white : Colors.redAccent),
                            label: Text(rec ? 'Stop Rec' : 'Rec'),
                            style: ElevatedButton.styleFrom(backgroundColor: rec ? Colors.red : null),
                          );
                        },
                      ),
                      const SizedBox(width: 6),
                      ValueListenableBuilder<bool>(
                        valueListenable: hasRecordingListenable,
                        builder: (context, has, _) {
                          return OutlinedButton.icon(
                            onPressed: has ? onPlayRecording : null,
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Play'),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ValueListenableBuilder<int>(
                        valueListenable: beatListenable,
                        builder: (context, beat, _) {
                          final scale = (beat % 2 == 0) ? 1.0 : 1.25;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 120),
                            width: 14 * scale,
                            height: 14 * scale,
                            decoration: const BoxDecoration(color: Colors.black87, shape: BoxShape.circle),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      const Text('Metronom'),
                      const SizedBox(width: 6),
                      ValueListenableBuilder<bool>(
                        valueListenable: metronomeOnListenable,
                        builder: (context, on, _) {
                          return Switch(value: on, onChanged: onMetronomeToggle);
                        },
                      ),
                      const SizedBox(width: 6),
                      ValueListenableBuilder<int>(
                        valueListenable: bpmListenable,
                        builder: (context, bpm, _) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('BPM: $bpm'),
                              SizedBox(
                                width: 160,
                                child: Slider(
                                  min: 60, max: 160, divisions: 100,
                                  value: bpm.toDouble(),
                                  onChanged: (v) => onTempoChange(v.round()),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
