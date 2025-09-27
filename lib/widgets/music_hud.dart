
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/progress_service.dart';
import 'package:alesia/widgets/rhythm_overlay.dart';
import 'package:flutter/material.dart';

class MusicHUD extends StatelessWidget {
  final ValueListenable<RhythmState> coachState;
  final VoidCallback onStart;
  final VoidCallback onStop;

  final ValueListenable<bool> metronomeOn;
  final ValueListenable<int> metronomeBeat;
  final int Function() getBpm;
  final void Function(int) setBpm;
  final VoidCallback toggleMetronome;

  final VoidCallback startRec;
  final VoidCallback stopRec;
  final VoidCallback playRec;
  final ValueListenable<bool> hasRecording;

  const MusicHUD({
    super.key,
    required this.coachState,
    required this.onStart,
    required this.onStop,
    required this.metronomeOn,
    required this.metronomeBeat,
    required this.getBpm,
    required this.setBpm,
    required this.toggleMetronome,
    required this.startRec,
    required this.stopRec,
    required this.playRec,
    required this.hasRecording,
  });

  @override
  Widget build(BuildContext context) {
    final progress = getIt<ProgressService>();
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Material(
            color: Colors.white.withOpacity(0.92),
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValueListenableBuilder<RhythmState>(
                    valueListenable: coachState,
                    builder: (context, st, _) {
                      return Row(
                        children: [
                          Container(width: 10, height: 10, decoration: BoxDecoration(color: _phaseColor(st.phase), shape: BoxShape.circle)),
                          const SizedBox(width: 8),
                          Expanded(child: Text(st.message, style: const TextStyle(fontWeight: FontWeight.bold))),
                          ElevatedButton(onPressed: onStart, child: const Text('Start')),
                          const SizedBox(width: 6),
                          OutlinedButton(onPressed: onStop, child: const Text('Stop')),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ValueListenableBuilder<bool>(
                        valueListenable: metronomeOn,
                        builder: (context, isOn, _) {
                          return Row(
                            children: [
                              Switch(value: isOn, onChanged: (_) => toggleMetronome()),
                              const Text('Metronom'),
                            ],
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      ValueListenableBuilder<int>(
                        valueListenable: metronomeBeat,
                        builder: (context, beat, _) {
                          return AnimatedScale(
                            scale: 1.0 + (beat % 2 == 0 ? 0.15 : 0.0),
                            duration: const Duration(milliseconds: 120),
                            child: const Icon(Icons.circle, size: 14, color: Colors.deepPurple),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      Text('BPM: ${getBpm()}'),
                      Expanded(
                        child: Slider(
                          min: 60, max: 160, value: getBpm().toDouble(),
                          onChanged: (v) => setBpm(v.round()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ValueListenableBuilder<bool>(
                        valueListenable: hasRecording,
                        builder: (context, has, _) {
                          return Row(
                            children: [
                              ElevatedButton.icon(onPressed: startRec, icon: const Icon(Icons.fiber_manual_record), label: const Text('REC')),
                              const SizedBox(width: 6),
                              OutlinedButton.icon(onPressed: stopRec, icon: const Icon(Icons.stop), label: const Text('Stop')),
                              const SizedBox(width: 6),
                              FilledButton.icon(onPressed: has ? playRec : null, icon: const Icon(Icons.play_arrow), label: const Text('Play')),
                            ],
                          );
                        },
                      ),
                      const Spacer(),
                      ValueListenableBuilder<List<String>>(
                        valueListenable: progress.stickers,
                        builder: (context, list, _) {
                          return TextButton.icon(
                            onPressed: () => _showStickers(context, list),
                            icon: const Icon(Icons.emoji_events_outlined),
                            label: Text('Stickere: ${list.length}'),
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

  Color _phaseColor(RhythmPhase p) {
    switch (p) {
      case RhythmPhase.demo: return Colors.blueAccent;
      case RhythmPhase.user: return Colors.deepPurple;
      case RhythmPhase.success: return Colors.green;
      case RhythmPhase.fail: return Colors.redAccent;
      case RhythmPhase.idle: default: return Colors.grey;
    }
  }

  void _showStickers(BuildContext context, List<String> list) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Colecția mea de stickere', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12),
                  itemCount: list.length,
                  itemBuilder: (context, idx) {
                    final id = list[idx];
                    return Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              // TODO (Răzvan): Înlocuiește cu sprite sticker final 'assets/images/final/<id>.png'
                              'assets/images/placeholders/placeholder_square.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(id, maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
