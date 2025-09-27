import 'dart:math';
import 'package:flutter/material.dart';

class SpectrumVisualizer extends StatefulWidget {
  final ValueListenable<double> progress; // 0..1
  final int bars;
  const SpectrumVisualizer({super.key, required this.progress, this.bars = 24});

  @override
  State<SpectrumVisualizer> createState() => _SpectrumVisualizerState();
}

class _SpectrumVisualizerState extends State<SpectrumVisualizer> {
  double _seed = 0;

  @override
  void initState() {
    super.initState();
    widget.progress.addListener(_tick);
  }

  @override
  void dispose() {
    widget.progress.removeListener(_tick);
    super.dispose();
  }

  void _tick() {
    setState(() {
      _seed = widget.progress.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SpectrumPainter(seed: _seed, bars: widget.bars),
      size: Size.infinite,
    );
  }
}

class _SpectrumPainter extends CustomPainter {
  final double seed;
  final int bars;
  _SpectrumPainter({required this.seed, required this.bars});

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = Random(seed.hashCode);
    final w = size.width / bars;
    final paint = Paint()..color = Colors.deepPurpleAccent;
    for (int i=0;i<bars;i++) {
      final x = i * w + w/4;
      final h = (sin(seed*10 + i*0.6) * 0.5 + 0.5) * size.height * (0.25 + rnd.nextDouble()*0.25);
      final rect = Rect.fromLTWH(x, size.height - h, w/2, h);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SpectrumPainter oldDelegate) => oldDelegate.seed != seed || oldDelegate.bars != bars;
}
