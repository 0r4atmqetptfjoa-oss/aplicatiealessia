import 'package:flutter/material.dart';
import 'dart:math';

class RealtimeSpectrum extends StatelessWidget {
  final ValueListenable<List<double>> magnitudes;
  final double barSpacing;
  const RealtimeSpectrum({super.key, required this.magnitudes, this.barSpacing = 2});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<double>>(
      valueListenable: magnitudes,
      builder: (context, mags, _) {
        return CustomPaint(
          painter: _BarsPainter(mags: mags),
          size: Size.infinite,
        );
      },
    );
  }
}

class _BarsPainter extends CustomPainter {
  final List<double> mags;
  _BarsPainter({required this.mags});

  @override
  void paint(Canvas canvas, Size size) {
    if (mags.isEmpty) return;
    final barW = size.width / mags.length;
    for (int i = 0; i < mags.length; i++) {
      final h = mags[i].clamp(0.0, 1.0) * size.height;
      final rect = Rect.fromLTWH(i * barW + barW*0.25, size.height - h, barW*0.5, h);
      final c = HSVColor.fromAHSV(1, i / mags.length * 300, 0.7, 0.9).toColor();
      final paint = Paint()..color = c;
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BarsPainter oldDelegate) => oldDelegate.mags != mags;
}
