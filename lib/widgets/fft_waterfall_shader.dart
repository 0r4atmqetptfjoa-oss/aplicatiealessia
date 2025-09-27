
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Shader-based waterfall with palette & blur. Falls back to CPU painter if shader fails.
class FftWaterfallShader extends StatefulWidget {
  final int history; // rows
  final int bins; // columns
  final double height;
  final int fps;
  final double blur; // 0..1
  final int palette; // 0,1,2
  const FftWaterfallShader({
    super.key,
    this.history = 96,
    this.bins = 64,
    this.height = 180,
    this.fps = 30,
    this.blur = 0.6,
    this.palette = 0,
  });

  @override
  State<FftWaterfallShader> createState() => _FftWaterfallShaderState();
}

class _FftWaterfallShaderState extends State<FftWaterfallShader> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late List<Float32List> _rows;
  ui.FragmentProgram? _program;
  ui.FragmentShader? _shader;
  ui.Image? _texture;
  int _frameSkip = 0;

  @override
  void initState() {
    super.initState();
    _rows = List.generate(widget.history, (_) => Float32List(widget.bins));
    _ticker = createTicker((_) => _tick())..start();
    _loadShader();
  }

  Future<void> _loadShader() async {
    try {
      _program = await ui.FragmentProgram.fromAsset('assets/shaders/fft_waterfall.frag');
      setState(() {});
    } catch (_) {
      // stays null -> fallback mode
    }
  }

  @override
  void dispose() {
    _ticker.stop();
    _texture?.dispose();
    super.dispose();
  }

  void _tick() {
    // Throttle to target fps
    if (++_frameSkip < (60 / widget.fps).ceil()) return;
    _frameSkip = 0;

    try {
      final ad = getIt<AudioService>().audioData;
      ad.updateSamples();
      final samples = ad.getAudioData(alwaysReturnData: false);
      if (samples.isEmpty) return;
      final slice = samples.sublist(0, widget.bins);
      final f = Float32List(widget.bins);
      for (int i=0;i<widget.bins && i<slice.length;i++) {
        f[i] = slice[i].clamp(0, 1);
      }
      _rows.removeAt(0);
      _rows.add(f);
      _rebuildTexture();
      if (mounted) setState(() {});
    } catch (_) {
      // ignore
    }
  }

  Future<void> _rebuildTexture() async {
    final w = widget.bins;
    final h = widget.history;
    final bytes = Uint8List(w * h * 4);
    int k = 0;
    for (int y=0;y<h;y++) {
      final row = _rows[y];
      for (int x=0;x<w;x++) {
        final v = ((row[x]) * 255).clamp(0,255).toInt();
        bytes[k++] = v; // R
        bytes[k++] = v; // G
        bytes[k++] = v; // B
        bytes[k++] = 255; // A
      }
    }
    final desc = ui.ImageDescriptor.raw(
      await ui.ImmutableBuffer.fromUint8List(bytes),
      width: w,
      height: h,
      pixelFormat: ui.PixelFormat.rgba8888,
    );
    final codec = await desc.instantiateCodec();
    final frame = await codec.getNextFrame();
    _texture?.dispose();
    _texture = frame.image;
  }

  @override
  Widget build(BuildContext context) {
    final tex = _texture;
    if (_program == null || tex == null) {
      // CPU fallback
      return SizedBox(height: widget.height, child: CustomPaint(painter: _FallbackPainter(_rows)));
    }

    final shader = _program!.fragmentShader();
    shader.setImageSampler(0, tex);
    shader.setFloatUniforms((Float32List(2)..[0]=tex.width.toDouble()..[1]=tex.height.toDouble()));
    shader.setFloatUniforms((Float32List(2)..[0]=context.size?.width ?? 300..[1]=widget.height), startIndex: 2);
    shader.setFloat(4, widget.palette.toDouble());
    shader.setFloat(5, widget.blur.toDouble());

    return SizedBox(
      height: widget.height,
      child: CustomPaint(
        painter: _ShaderPainter(shader),
      ),
    );
  }
}

class _ShaderPainter extends CustomPainter {
  final ui.FragmentShader shader;
  _ShaderPainter(this.shader);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }
  @override
  bool shouldRepaint(covariant _ShaderPainter oldDelegate) => true;
}

class _FallbackPainter extends CustomPainter {
  final List<Float32List> data;
  _FallbackPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final rows = data.length;
    final cols = data.first.length;
    final cw = size.width / cols;
    final ch = size.height / rows;
    final paint = Paint();
    for (int y=0;y<rows;y++) {
      final row = data[y];
      for (int x=0;x<cols;x++) {
        final v = row[x].clamp(0,1);
        paint.color = Color.lerp(Colors.black, Colors.purpleAccent, v)!;
        canvas.drawRect(Rect.fromLTWH(x*cw, y*ch, cw, ch), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _FallbackPainter oldDelegate) => true;
}
