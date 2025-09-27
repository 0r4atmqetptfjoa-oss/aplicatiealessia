import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SoundsMapScreen extends StatelessWidget {
  const SoundsMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = getIt<AudioService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Harta Sunetelor')),
      body: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              // TODO (Răzvan): Înlocuiește cu resursa finală 'harta_interactiva.png'.
              child: Image.asset('assets/images/placeholders/placeholder_landscape.png', fit: BoxFit.cover),
            ).animate().fadeIn(duration: 400.ms),
          ),
          _zoneButton(context, 'Fermă', const Offset(0.25, 0.6), onTap: () => audio.playTap()),
          _zoneButton(context, 'Junglă', const Offset(0.5, 0.35), onTap: () => audio.playTap()),
          _zoneButton(context, 'Oraș', const Offset(0.78, 0.7), onTap: () => audio.playTap()),
        ],
      ),
    );
  }

  Widget _zoneButton(BuildContext context, String label, Offset fraction, {required VoidCallback onTap}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dx = constraints.maxWidth * fraction.dx;
        final dy = constraints.maxHeight * fraction.dy;
        return Positioned(
          left: dx - 40,
          top: dy - 40,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                shape: BoxShape.circle,
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
              ),
              alignment: Alignment.center,
              child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            ).animate().scale(duration: 250.ms, curve: Curves.easeOutBack),
          ),
        );
      },
    );
  }
}
