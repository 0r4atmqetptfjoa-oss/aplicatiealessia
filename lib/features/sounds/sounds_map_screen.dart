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
          // TODO (Răzvan): Înlocuiește cu 'assets/images/final/harta_interactiva.png'
          Positioned.fill(
            child: Image.asset('assets/images/placeholders/placeholder_landscape.png', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Stack(
              children: [
                _IconButtonAt(
                  top: 80, left: 40,
                  label: 'Vaca',
                  // TODO (Răzvan): Înlocuiește cu 'assets/images/final/vaca.png'
                  iconPath: 'assets/images/placeholders/placeholder_square.png',
                  onTap: () => audio.playTap(),
                ),
                _IconButtonAt(
                  top: 140, right: 50,
                  label: 'Leu',
                  // TODO (Răzvan): Înlocuiește cu 'assets/images/final/leu.png'
                  iconPath: 'assets/images/placeholders/placeholder_square.png',
                  onTap: () => audio.playTap(),
                ),
                _IconButtonAt(
                  bottom: 90, left: 50,
                  label: 'Mașină',
                  // TODO (Răzvan): Înlocuiește cu 'assets/images/final/masina.png'
                  iconPath: 'assets/images/placeholders/placeholder_square.png',
                  onTap: () => audio.playTap(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconButtonAt extends StatelessWidget {
  final double? top, left, right, bottom;
  final String label;
  final String iconPath;
  final VoidCallback onTap;

  const _IconButtonAt({
    this.top, this.left, this.right, this.bottom,
    required this.label,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top, left: left, right: right, bottom: bottom,
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: const [BoxShadow(blurRadius: 8, offset: Offset(0, 4), color: Colors.black26)],
              ),
              child: ClipOval(
                child: Image.asset(iconPath, width: 64, height: 64, fit: BoxFit.cover),
              ),
            ).animate(onPlay: (c) => c.repeat(period: 1500.ms))
             .scale(begin: const Offset(1,1), end: const Offset(1.06,1.06), duration: 1500.ms, curve: Curves.easeInOut),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }
}
