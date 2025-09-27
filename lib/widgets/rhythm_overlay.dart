import 'package:flutter/material.dart';

enum RhythmPhase { idle, demo, user, success, fail }

class RhythmState {
  final RhythmPhase phase;
  final int progress; // câți pași a făcut utilizatorul
  final int length;   // lungimea modelului
  final int streak;   // combo/serii reușite
  final String message;
  const RhythmState({required this.phase, required this.progress, required this.length, required this.streak, required this.message});
}

typedef RhythmStart = void Function();
typedef RhythmStop = void Function();

class RhythmOverlay extends StatelessWidget {
  final ValueListenable<RhythmState> stateListenable;
  final RhythmStart onStart;
  final RhythmStop onStop;
  const RhythmOverlay({super.key, required this.stateListenable, required this.onStart, required this.onStop});

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
          padding: const EdgeInsets.all(12),
          child: Material(
            color: Colors.white.withOpacity(0.9),
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ValueListenableBuilder<RhythmState>(
                valueListenable: stateListenable,
                builder: (context, state, _) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 10, height: 10,
                        decoration: BoxDecoration(color: _phaseColor(state.phase), shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 8),
                      Text(state.message, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 12),
                      Row(
                        children: List.generate(state.length, (i) {
                          final filled = i < state.progress;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Icon(filled ? Icons.circle : Icons.circle_outlined, size: 12),
                          );
                        }),
                      ),
                      const SizedBox(width: 12),
                      Text('x${state.streak}', style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(width: 12),
                      ElevatedButton(onPressed: onStart, child: const Text('Start')),
                      const SizedBox(width: 6),
                      OutlinedButton(onPressed: onStop, child: const Text('Stop')),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
