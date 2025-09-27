import 'package:flutter/material.dart';

class SongMarker {
  final double t; // seconds
  final String label;
  const SongMarker(this.t, this.label);
}

class SongTimeline extends StatelessWidget {
  final double progress; // 0..1
  final Duration duration;
  final List<SongMarker> markers;
  final bool seekingEnabled;
  final ValueChanged<double>? onSeekTo; // 0..1
  final ValueChanged<double>? onJumpTo; // seconds

  const SongTimeline({
    super.key,
    required this.progress,
    required this.duration,
    this.markers = const [],
    this.seekingEnabled = false,
    this.onSeekTo,
    this.onJumpTo,
  });

  String _fmt(Duration d) {
    final mm = d.inMinutes.remainder(60).toString().padLeft(2,'0');
    final ss = d.inSeconds.remainder(60).toString().padLeft(2,'0');
    return '$mm:$ss';
    }

  @override
  Widget build(BuildContext context) {
    final pos = duration * progress;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(_fmt(pos)),
            Expanded(
              child: Slider(
                value: progress.clamp(0, 1),
                onChanged: seekingEnabled ? (v) => onSeekTo?.call(v) : null,
              ),
            ),
            Text(_fmt(duration)),
          ],
        ),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: markers.map((m) => ActionChip(
            label: Text(m.label),
            onPressed: () => onJumpTo?.call(m.t),
          )).toList(),
        ),
      ],
    );
  }
}
