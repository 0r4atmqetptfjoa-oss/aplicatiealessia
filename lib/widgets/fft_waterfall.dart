import 'dart:math';
import 'dart:typed_data';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class FftWaterfall extends StatefulWidget {
  final int rows; // număr de linii istorice
  final int cols; // număr de benzi (FFT downsampled)
  final double height;
  const FftWaterfall({super.key, this.rows = 120, this.cols = 48, this.height = 160});

  @override
  State<FftWaterfall> createState() => _FftWaterfallState();
}

class _FftWaterfallState extends State<FftWaterfall> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late List<List<double>> _buf; // rows x cols, valori [0..1]

  @override
  void initState() {
    super.initState();
    _buf = List.generate(widget.rows, (_) => List.filled(widget.cols, 0.0));
    _ticker = createTicker((_) => _tick())..start();
  }

  @override
  void dispose() {
    _ticker.stop();
    super.dispose();
  }

  void _tick() {
    try {
      final ad = getIt<AudioService>().audioData;
      ad.updateSamples();
      final samples = ad.getAudioData(alwaysReturnData: false);
      if (samples.isEmpty) return;
      final fft = samples.sublist(0, 256);
      final cols = widget.cols;
      final step = (fft.length / cols).floor().clamp(1, fft.length);
      final row = <double>[];
      double acc = 0; int cnt = 0;
      for (int i=0;i<fft.length;i++){
        acc += fft[i];
        cnt++;
        if (cnt == step) {
          row.add((acc/step).clamp(0, 1));
          acc = 0; cnt = 0;
        }
      }
      while (row.length < cols) { row.add(0); }
      // shift buffer
      _buf.removeAt(0);
      _buf.add(row);
      setState((){});
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: CustomPaint(
        painter: _WaterfallPainter(_buf),
      ),
    );
  }
}

class _WaterfallPainter extends CustomPainter {
  final List<List<double>> buf;
  _WaterfallPainter(this.buf);

  @override
  void paint(Canvas canvas, Size size) {
    final rows = buf.length;
    final cols = buf.isEmpty ? 0 : buf[0].length;
    if (rows == 0 || cols == 0) return;

    final cw = size.width / cols;
    final ch = size.height / rows;

    for (int r=0;r<rows;r++){
      for (int c=0;c<cols;c++){
        final v = buf[r][c];
        final color = _palette(v);
        final rect = Rect.fromLTWH(c*cw, r*ch, cw+0.5, ch+0.5);
        final paint = Paint()..color = color;
        canvas.drawRect(rect, paint);
      }
    }
  }

  Color _palette(double t) {
    // colormap „plasmă” simplificată
    t = t.clamp(0.0, 1.0);
    final r = (0.5 + 1.5*t).clamp(0.0, 1.0);
    final g = (1.2*t*(1.0 - (t-0.5)*(t-0.5)*4)).clamp(0.0, 1.0);
    final b = (1.0 - t).clamp(0.0, 1.0);
    return Color.fromRGBO((r*255).toInt(), (g*255).toInt(), (b*255).toInt(), 1);
  }

  @override
  bool shouldRepaint(covariant _WaterfallPainter oldDelegate) => true;
}
