import 'package:flutter/material.dart';

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
            child: Row(
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
          ),
        ),
      ),
    );
  }
}
