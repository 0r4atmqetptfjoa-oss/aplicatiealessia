import 'dart:typed_data';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class FftBands extends StatefulWidget {
  final double height;
  final int bars;
  final EdgeInsetsGeometry padding;
  const FftBands({super.key, this.height = 120, this.bars = 48, this.padding = const EdgeInsets.symmetric(horizontal: 12)});

  @override
  State<FftBands> createState() => _FftBandsState();
}

class _FftBandsState extends State<FftBands> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Float32List? _fft;

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
      setState(() {
        _fft = samples.sublist(0, 256);
      });
    } catch (_) {
      // ignore in case no playback.
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _fft ?? Float32List(256);
    final len = data.length;
    final step = (len / widget.bars).floor().clamp(1, len);
    final bands = <double>[];
    double acc = 0; int cnt = 0;
    for (int i=0;i<len;i++) {
      acc += data[i];
      cnt += 1;
      if (cnt == step) { bands.add((acc/step).clamp(0, 1)); acc = 0; cnt = 0; }
    }
    if (cnt>0) bands.add((acc/cnt).clamp(0,1));

    return SizedBox(
      height: widget.height,
      child: Padding(
        padding: widget.padding,
        child: CustomPaint(painter: _BandsPainter(bands)),
      ),
    );
  }
}

class _BandsPainter extends CustomPainter {
  final List<double> bands;
  _BandsPainter(this.bands);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width / (bands.isEmpty?1:bands.length);
    final paint = Paint()..color = Colors.deepPurpleAccent;
    for (int i=0;i<bands.length;i++){
      final h = bands[i] * size.height;
      final rect = Rect.fromLTWH(i*w + w*0.15, size.height - h, w*0.7, h);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BandsPainter oldDelegate) => oldDelegate.bands != bands;
}
