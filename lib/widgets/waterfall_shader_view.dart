import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:alesia/widgets/fft_waterfall.dart';

class WaterfallPalette {
  final List<Color> colors;
  final List<double>? stops;
  const WaterfallPalette(this.colors, {this.stops});
  static WaterfallPalette magma() => const WaterfallPalette([
    Color(0xFF000004), Color(0xFF1B0C41), Color(0xFF4A0C6B), Color(0xFF781C6D),
    Color(0xFFA52C60), Color(0xFFC73E4C), Color(0xFFD95F0E), Color(0xXFDE725)
  ]);
  static WaterfallPalette ocean() => const WaterfallPalette([
    Color(0xFF001219), Color(0xFF005F73), Color(0xFF0A9396), Color(0xFF94D2BD),
    Color(0xFFE9D8A6), Color(0xFFEE9B00), Color(0xFFCA6702), Color(0xFFBB3E03)
  ]);
  static WaterfallPalette pixarWarm() => const WaterfallPalette([
    Color(0xFF1F005C), Color(0xFF5B0060), Color(0xFF870160), Color(0xFFAC255E),
    Color(0xFFCA485C), Color(0xFFE16B5C), Color(0xFFF39060), Color(0xFFF9C74F)
  ]);
}

class WaterfallShaderView extends StatelessWidget {
  final double height;
  final WaterfallPalette palette;
  final double blurSigma;
  const WaterfallShaderView({super.key, required this.height, required this.palette, this.blurSigma = 1.5});

  @override
  Widget build(BuildContext context) {
    final grad = LinearGradient(colors: palette.colors, stops: palette.stops);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (rect) => grad.createShader(rect),
          child: FftWaterfall(height: height, grayscale: true),
        ),
      ),
    );
  }
}
