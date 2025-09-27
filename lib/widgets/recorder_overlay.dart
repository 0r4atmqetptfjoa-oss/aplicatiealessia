import 'package:flutter/material.dart';

class RecorderOverlay extends StatelessWidget {
  final bool isRecording;
  final bool hasRecording;
  final VoidCallback onRecordStart;
  final VoidCallback onRecordStop;
  final VoidCallback onPlayback;
  const RecorderOverlay({
    super.key,
    required this.isRecording,
    required this.hasRecording,
    required this.onRecordStart,
    required this.onRecordStop,
    required this.onPlayback,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Material(
            color: Colors.white.withOpacity(0.9),
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isRecording)
                    ElevatedButton.icon(
                      onPressed: onRecordStart,
                      icon: const Icon(Icons.fiber_manual_record),
                      label: const Text('Înregistrează'),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: onRecordStop,
                      icon: const Icon(Icons.stop),
                      label: const Text('Stop'),
                    ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: hasRecording ? onPlayback : null,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Redă'),
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
