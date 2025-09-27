import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class SpectrumVisualizer extends StatefulWidget {
  final ValueListenable<double> positionSec;
  final int bars;
  final int bpm;
  final String variant; // 'A' bare, 'B' cercuri
  const SpectrumVisualizer({super.key, required this.positionSec, required this.bars, required this.bpm, this.variant = 'A'});

  @override
  State<SpectrumVisualizer> createState() => _SpectrumVisualizerState();
}

class _SpectrumVisualizerState extends State<SpectrumVisualizer> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  double _t = 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((dt) {
      setState(() { _t += dt.inMilliseconds / 1000.0; });
    })..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pos = widget.positionSec.value;
    final ph = (pos * widget.bpm / 60.0) * 2 * pi;
    return CustomPaint(
      painter: _SpecPainter(bars: widget.bars, phase: ph + _t, variant: widget.variant),
      child: const SizedBox(height: 120),
    );
  }
}

class _SpecPainter extends CustomPainter {
  final int bars;
  final double phase;
  final String variant;
  _SpecPainter({required this.bars, required this.phase, required this.variant});

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = Random(42);
    final w = size.width / (bars * 1.2);
    for (int i = 0; i < bars; i++) {
      final x = (i + 0.5) * w * 1.2;
      final amp = (sin(phase + i * 0.6) + 1) / 2;       // 0..1
      final jitter = (rnd.nextDouble() * 0.2);
      final h = size.height * (0.2 + 0.8 * (amp * 0.8 + jitter * 0.2));
      final rect = Rect.fromCenter(center: Offset(x, size.height - h / 2), width: w * 0.8, height: h);
      final paint = Paint()..color = Colors.white.withOpacity(0.9);
      if (variant == 'B') {
        canvas.drawCircle(Offset(x, size.height - h), w * 0.6, paint);
      } else {
        final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(8));
        canvas.drawRRect(rrect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SpecPainter old) => old.phase != phase || old.variant != variant || old.bars != bars;
}