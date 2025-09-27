import 'dart:math';
import 'dart:typed_data';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class FftParticles extends StatefulWidget {
  final double height;
  const FftParticles({super.key, this.height = 120});

  @override
  State<FftParticles> createState() => _FftParticlesState();
}

class _FftParticlesState extends State<FftParticles> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final rnd = Random();
  Float32List? _fft;
  final List<_P> _ps = [];

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
      _fft = samples.sublist(0, 256);
      final energy = _fft!.fold<double>(0, (p, e) => p + e)/_fft!.length;
      if (energy > 0.15) {
        // spawn a few particles proportional to energy
        for (int i=0;i<(energy*20).clamp(1,6).toInt(); i++){
          _ps.add(_P(x: rnd.nextDouble(), vy: -0.005 - rnd.nextDouble()*0.01, life: 1.0));
        }
      }
      // update particles
      for (final p in _ps) {
        p.y += p.vy;
        p.life -= 0.02;
      }
      _ps.removeWhere((p) => p.life <= 0 || p.y < -0.1);
      setState((){});
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: CustomPaint(painter: _ParticlesPainter(_ps)),
    );
  }
}

class _P {
  double x; double y=1; double vy; double life;
  _P({required this.x, required this.vy, required this.life});
}

class _ParticlesPainter extends CustomPainter {
  final List<_P> ps;
  _ParticlesPainter(this.ps);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.pinkAccent.withOpacity(0.8);
    for (final p in ps) {
      final r = 4.0 * p.life;
      canvas.drawCircle(Offset(p.x*size.width, p.y*size.height), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter oldDelegate) => true;
}
