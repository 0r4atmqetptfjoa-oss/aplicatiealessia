import 'dart:math';
import 'dart:typed_data';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class FftWaterfall extends StatefulWidget {
  final bool grayscale;
  const FftWaterfall({super.key, this.history = 64, this.bins = 64, this.height = 160, this.grayscale = false});
  final int bands;
  final int history; // număr de coloane în istoric
  final double height;
  const FftWaterfall({super.key, this.bands = 64, this.history = 120, this.height = 160});

  @override
  State<FftWaterfall> createState() => _FftWaterfallState();
}

class _FftWaterfallState extends State<FftWaterfall> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final List<Float32List> _cols = [];

  @override
  void initState() {
    super.initState();
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
      final col = _downsample(fft, widget.bands);
      _cols.add(col);
      if (_cols.length > widget.history) {
        _cols.removeAt(0);
      }
      setState((){});
    } catch (_) {}
  }

  Float32List _downsample(Float32List src, int n) {
    final len = src.length;
    final step = max(1, (len / n).floor());
    final out = Float32List(n);
    var acc = 0.0; var cnt = 0; var idx = 0; var outIdx = 0;
    while (idx < len && outIdx < n) {
      acc += src[idx]; cnt++;
      if (cnt == step) {
        out[outIdx++] = (acc / step).clamp(0.0, 1.0);
        acc = 0.0; cnt = 0;
      }
      idx++;
    }
    while (outIdx < n) { out[outIdx++] = 0.0; } // padding
    return out;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: CustomPaint(
        painter: _WaterfallPainter(_cols, bands: widget.bands),
      ),
    );
  }
}

class _WaterfallPainter extends CustomPainter {
  final List<Float32List> cols;
  final int bands;
  _WaterfallPainter(this.cols, {required this.bands});

  @override
  void paint(Canvas canvas, Size size) {
    if (cols.isEmpty) return;
    final w = size.width / cols.length;
    final h = size.height / bands;
    for (int x = 0; x < cols.length; x++) {
      final col = cols[x];
      for (int y = 0; y < bands; y++) {
        final v = y < col.length ? col[y] : 0.0;
        final paint = Paint()..color = _colorFor(v);
        final rect = Rect.fromLTWH(x * w, size.height - (y+1) * h, w+0.5, h+0.5);
        canvas.drawRect(rect, paint);
      }
    }
  }

  Color _colorFor(double v) {
    // Gradient simplu: albastru -> cian -> verde -> galben -> roșu
    v = v.clamp(0.0, 1.0);
    final stops = [
      Colors.blue,
      Colors.cyan,
      Colors.green,
      Colors.yellow,
      Colors.red,
    ];
    final idx = (v * (stops.length - 1)).clamp(0, stops.length - 1 - 1).floor();
    final t = (v * (stops.length - 1)) - idx;
    return Color.lerp(stops[idx], stops[idx + 1], t)!;
  }

  @override
  bool shouldRepaint(covariant _WaterfallPainter oldDelegate) => true;
}
