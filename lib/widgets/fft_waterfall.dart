import 'dart:math';
import 'dart:typed_data';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class FftWaterfall extends StatefulWidget {
  final int history; // număr linii istorice
  final int bins; // număr de benzi FFT folosite
  final double height;
  const FftWaterfall({super.key, this.history = 64, this.bins = 64, this.height = 160});

  @override
  State<FftWaterfall> createState() => _FftWaterfallState();
}

class _FftWaterfallState extends State<FftWaterfall> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  List<Float32List> _buffer = [];
  final _rnd = Random();

  @override
  void initState() {
    super.initState();
    _buffer = List.generate(widget.history, (_) => Float32List(widget.bins));
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
      final slice = samples.sublist(0, max(widget.bins, 1));
      // normalizează ușor
      final f = Float32List(widget.bins);
      for (int i=0; i<widget.bins && i<slice.length; i++) {
        f[i] = slice[i].clamp(0, 1);
      }
      // circular buffer: elimină primul, adaugă la final
      _buffer.removeAt(0);
      _buffer.add(f);
      setState((){});
    } catch (_) {
      // fallback: puțin zgomot ca să nu înghețe
      final f = Float32List(widget.bins);
      for (int i=0; i<widget.bins; i++) { f[i] = _rnd.nextDouble()*0.02; }
      _buffer.removeAt(0); _buffer.add(f); setState((){});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: widget.height, child: CustomPaint(painter: _WaterfallPainter(_buffer)));
  }
}

class _WaterfallPainter extends CustomPainter {
  final List<Float32List> data; // [rows][bins]
  _WaterfallPainter(this.data);

  Color _col(double v) {
    // map 0..1 -> gradient "cool to warm"
    v = v.clamp(0, 1);
    final r = (255 * v).round();
    final g = (255 * (1.0 - (v - 0.3).abs())).clamp(0, 255).round();
    final b = (255 * (1.0 - v)).round();
    return Color.fromARGB(255, r, g, b);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final rows = data.length;
    final cols = data.first.length;
    final cw = size.width / cols;
    final ch = size.height / rows;
    final paint = Paint();
    for (int y=0; y<rows; y++) {
      final row = data[y];
      for (int x=0; x<cols; x++) {
        paint.color = _col(row[x].toDouble());
        canvas.drawRect(Rect.fromLTWH(x*cw, y*ch, cw, ch), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _WaterfallPainter old) => true;
}
