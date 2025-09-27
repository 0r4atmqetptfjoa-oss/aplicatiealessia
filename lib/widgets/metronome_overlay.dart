import 'package:flutter/material.dart';

class MetronomeOverlay extends StatelessWidget {
  final ValueListenable<int> tickListenable;
  final int bpm;
  final ValueChanged<int> onBpmChanged;
  final VoidCallback onStart;
  final VoidCallback onStop;
  const MetronomeOverlay({
    super.key,
    required this.tickListenable,
    required this.bpm,
    required this.onBpmChanged,
    required this.onStart,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Material(
            color: Colors.white.withOpacity(0.9),
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValueListenableBuilder<int>(
                    valueListenable: tickListenable,
                    builder: (context, tick, _) {
                      return AnimatedScale(
                        scale: 1.0 + (tick % 2 == 0 ? 0.12 : 0.0),
                        duration: const Duration(milliseconds: 90),
                        child: const Icon(Icons.circle, size: 18),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  Text('BPM: $bpm', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 160,
                    child: Slider(
                      value: bpm.toDouble(),
                      min: 40, max: 160, divisions: 120,
                      onChanged: (v) => onBpmChanged(v.round()),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(onPressed: onStart, child: const Text('Metronom ON')),
                  const SizedBox(width: 6),
                  OutlinedButton(onPressed: onStop, child: const Text('OFF')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
