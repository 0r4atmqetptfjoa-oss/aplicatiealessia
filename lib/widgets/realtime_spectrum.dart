import 'package:flutter/material.dart';

class RealtimeSpectrum extends StatelessWidget {
  final ValueListenable<List<double>> bandsListenable;
  const RealtimeSpectrum({super.key, required this.bandsListenable});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<double>>(
      valueListenable: bandsListenable,
      builder: (context, bands, _) {
        return CustomPaint(
          size: Size.infinite,
          painter: _BarsPainter(bands),
        );
      },
    );
  }
}

class _BarsPainter extends CustomPainter {
  final List<double> bands;
  _BarsPainter(this.bands);

  @override
  void paint(Canvas canvas, Size size) {
    if (bands.isEmpty) return;
    final w = size.width / bands.length;
    final paint = Paint()..color = Colors.deepPurpleAccent;
    for (int i = 0; i < bands.length; i++) {
      final h = bands[i].clamp(0.0, 1.0) * size.height;
      final rect = Rect.fromLTWH(i * w + w * 0.2, size.height - h, w * 0.6, h);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(3)), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BarsPainter oldDelegate) => oldDelegate.bands != bands;
}
