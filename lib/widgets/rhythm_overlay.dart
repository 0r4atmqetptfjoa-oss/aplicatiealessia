import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/profile_service.dart';
import 'package:flutter/material.dart';

enum RhythmPhase { idle, demo, user, success, fail }

class RhythmState {
  final RhythmPhase phase;
  final int progress; // câți pași a făcut utilizatorul
  final int length;   // lungimea modelului
  final int streak;   // combo/serii reușite
  final String message;
  final int bpm;
  final bool metronomeOn;
  const RhythmState({
    required this.phase,
    required this.progress,
    required this.length,
    required this.streak,
    required this.message,
    required this.bpm,
    required this.metronomeOn,
  });
}

typedef RhythmStart = void Function();
typedef RhythmStop = void Function();
typedef Void = void Function();

class RhythmOverlay extends StatelessWidget {
  final ValueListenable<RhythmState> stateListenable;
  final ValueListenable<int> beatListenable;
  final RhythmStart onStart;
  final RhythmStop onStop;
  final Void onTempoUp;
  final Void onTempoDown;
  final Void onToggleMetronome;
  final Void onStartRec;
  final Void onStopRec;
  final Void onPlayRec;
  final Void onClearRec;

  const RhythmOverlay({
    super.key,
    required this.stateListenable,
    required this.beatListenable,
    required this.onStart,
    required this.onStop,
    required this.onTempoUp,
    required this.onTempoDown,
    required this.onToggleMetronome,
    required this.onStartRec,
    required this.onStopRec,
    required this.onPlayRec,
    required this.onClearRec,
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
    final profile = getIt<ProfileService>();
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Material(
            color: Colors.white.withOpacity(0.95),
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // status + progres + streak + stele
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
                          const SizedBox(width: 12),
                          Row(children: [
                            const Icon(Icons.star, color: Colors.amber, size: 18),
                            const SizedBox(width: 4),
                            Text('${profile.stars}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ]),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  // Beat + BPM + metronom
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ValueListenableBuilder<int>(
                        valueListenable: beatListenable,
                        builder: (context, beat, _) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 120),
                            width: 14, height: 14,
                            decoration: BoxDecoration(
                              color: (beat % 2 == 0) ? Colors.black87 : Colors.black26,
                              shape: BoxShape.circle,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      ValueListenableBuilder<RhythmState>(
                        valueListenable: stateListenable,
                        builder: (context, s, _) => Text('BPM ${s.bpm}'),
                      ),
                      IconButton(onPressed: onTempoDown, icon: const Icon(Icons.remove), tooltip: 'Tempo -'),
                      IconButton(onPressed: onTempoUp, icon: const Icon(Icons.add), tooltip: 'Tempo +'),
                      const SizedBox(width: 8),
                      ValueListenableBuilder<RhythmState>(
                        valueListenable: stateListenable,
                        builder: (context, s, _) => Row(
                          children: [
                            Switch(value: s.metronomeOn, onChanged: (_) => onToggleMetronome()),
                            const Text('Metronom'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Butoane: Start/Stop + REC/PLAY
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(onPressed: onStart, child: const Text('Start')),
                      const SizedBox(width: 6),
                      OutlinedButton(onPressed: onStop, child: const Text('Stop')),
                      const SizedBox(width: 12),
                      FilledButton.tonal(onPressed: onStartRec, child: const Text('Rec')),
                      const SizedBox(width: 6),
                      FilledButton.tonal(onPressed: onStopRec, child: const Text('Stop Rec')),
                      const SizedBox(width: 6),
                      FilledButton(onPressed: onPlayRec, child: const Text('Play')),
                      const SizedBox(width: 6),
                      IconButton(onPressed: onClearRec, icon: const Icon(Icons.delete_outline)),
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
