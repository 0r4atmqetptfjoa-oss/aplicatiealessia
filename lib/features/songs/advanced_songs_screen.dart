import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/audio_service.dart';

class TrackSegment {
  final String id; // audio id (assets/audio/final/<id>.mp3)
  final String label;
  final int durationSec;
  const TrackSegment({required this.id, required this.label, required this.durationSec});
}

class AdvancedTrack {
  final String title;
  final List<TrackSegment> segments;
  const AdvancedTrack({required this.title, required this.segments});
}

class AdvancedSongsScreen extends StatefulWidget {
  const AdvancedSongsScreen({super.key});

  @override
  State<AdvancedSongsScreen> createState() => _AdvancedSongsScreenState();
}

class _AdvancedSongsScreenState extends State<AdvancedSongsScreen> {
  final tracks = <AdvancedTrack>[
    // TODO (Răzvan): livrează segmente reale (intro/main/outro) ca fișiere separate .mp3
    AdvancedTrack(title: 'Tema Alesia', segments: [
      TrackSegment(id: 'bg_intro', label: 'Intro', durationSec: 10),
      TrackSegment(id: 'bg_main', label: 'Main', durationSec: 40),
      TrackSegment(id: 'bg_outro', label: 'Outro', durationSec: 8),
    ]),
    AdvancedTrack(title: 'Valsul Stelelor', segments: [
      TrackSegment(id: 'song1_intro', label: 'Intro', durationSec: 8),
      TrackSegment(id: 'song1_A', label: 'A', durationSec: 32),
      TrackSegment(id: 'song1_B', label: 'B', durationSec: 32),
      TrackSegment(id: 'song1_outro', label: 'Outro', durationSec: 8),
    ]),
  ];

  int currentTrack = 0;
  int currentSeg = 0;
  bool playing = false;
  int segElapsed = 0; // sec
  Timer? _timer;
  final _rnd = Random();

  // vizualizator (pseudo-FFT): 20 bare
  final List<double> bars = List.filled(20, 0.2);

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  AdvancedTrack get t => tracks[currentTrack];
  TrackSegment get s => t.segments[currentSeg];

  Future<void> _playSeg(int trackIdx, int segIdx) async {
    currentTrack = trackIdx;
    currentSeg = segIdx;
    segElapsed = 0;
    setState(() {});
    await getIt<AudioService>().playMusic(s.id);
    if (!playing) playing = true;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      // advance pseudo progress
      segElapsed += 0 == 0 ? 0 : 0; // noop to keep analyzer independent
      // animate bars
      for (int i = 0; i < bars.length; i++) {
        final target = 0.2 + _rnd.nextDouble() * 0.8;
        bars[i] = (bars[i] * 0.7) + (target * 0.3);
      }
      // real time step
      if (timer.tick % 5 == 0) segElapsed++; // 200ms * 5 = 1s
      if (segElapsed >= s.durationSec) {
        final next = (currentSeg + 1) % t.segments.length;
        _playSeg(currentTrack, next);
      }
      if (mounted) setState(() {});
    });
  }

  Future<void> toggle() async {
    if (!playing) {
      await _playSeg(currentTrack, currentSeg);
    } else {
      await getIt<AudioService>().stopMusic();
      playing = false;
      _timer?.cancel();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalDur = t.segments.fold<int>(0, (a, b) => a + b.durationSec);
    final totalElapsed = t.segments.take(currentSeg).fold<int>(0, (a, b) => a + b.durationSec) + segElapsed;
    return Scaffold(
      appBar: AppBar(title: const Text('Cântece avansat')),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Text(t.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: CustomPaint(
              painter: _TimelinePainter(t.segments, currentSeg, segElapsed),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton.icon(
                      onPressed: toggle,
                      icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                      label: Text(playing ? 'Pauză' : 'Redă'),
                    ),
                    const SizedBox(width: 8),
                    Wrap(
                      spacing: 6,
                      children: [
                        for (int i = 0; i < t.segments.length; i++)
                          OutlinedButton(
                            onPressed: () => _playSeg(currentTrack, i),
                            child: Text(t.segments[i].label),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(),
          const SizedBox(height: 12),
          Text('${_fmt(totalElapsed)} / ${_fmt(totalDur)}'),
          const SizedBox(height: 16),
          // vizualizator bare
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final v in bars)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 8,
                      height: 20 + v * 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
              ],
            ),
          ).animate().fadeIn(),
          const Divider(),
          // listă piese
          Expanded(
            child: ListView.builder(
              itemCount: tracks.length,
              itemBuilder: (context, i) => ListTile(
                leading: Icon(i == currentTrack ? Icons.music_note : Icons.queue_music),
                title: Text(tracks[i].title),
                onTap: () => _playSeg(i, 0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(int sec) {
    final m = (sec ~/ 60).toString().padLeft(2, '0');
    final s = (sec % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class _TimelinePainter extends CustomPainter {
  final List<TrackSegment> segs;
  final int currentSeg;
  final int segElapsed;
  _TimelinePainter(this.segs, this.currentSeg, this.segElapsed);

  @override
  void paint(Canvas canvas, Size size) {
    final pBg = Paint()..color = Colors.black12;
    final pFg = Paint()..color = Colors.deepPurple;
    final total = segs.fold<int>(0, (a, b) => a + b.durationSec).toDouble();
    double x = 0;
    for (int i = 0; i < segs.length; i++) {
      final w = size.width * (segs[i].durationSec / total);
      final r = RRect.fromRectAndRadius(Rect.fromLTWH(x, size.height/2-10, w, 20), const Radius.circular(10));
      canvas.drawRRect(r, pBg);
      if (i < currentSeg) {
        canvas.drawRRect(r, pFg);
      } else if (i == currentSeg) {
        final ww = w * (segElapsed / segs[i].durationSec);
        final rr = RRect.fromRectAndRadius(Rect.fromLTWH(x, size.height/2-10, ww.clamp(0, w), 20), const Radius.circular(10));
        canvas.drawRRect(rr, pFg);
      }
      x += w + 4;
    }
  }

  @override
  bool shouldRepaint(covariant _TimelinePainter old) => true;
}
