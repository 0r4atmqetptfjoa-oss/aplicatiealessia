import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class XylophoneScreen extends StatelessWidget {
  const XylophoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = getIt<AudioService>();
    final colors = [
      Colors.red.shade400,
      Colors.orange.shade400,
      Colors.amber.shade400,
      Colors.green.shade400,
      Colors.teal.shade400,
      Colors.blue.shade400,
      Colors.indigo.shade400,
      Colors.purple.shade400,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Xilofon')),
      body: Stack(
        children: [
          // TODO (Răzvan): Înlocuiește cu 'assets/images/final/fundal_xilofon.png'
          Positioned.fill(
            child: Image.asset('assets/images/placeholders/placeholder_landscape.png', fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: List.generate(8, (i) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: _Bar(
                      color: colors[i % colors.length],
                      label: 'Nota ${i + 1}',
                      onTap: () => audio.playTap(),
                    ).animate().fadeIn(duration: 300.ms, delay: (i * 60).ms).slideY(begin: 0.12, end: 0, curve: Curves.easeOutBack),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatefulWidget {
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _Bar({required this.color, required this.label, required this.onTap});

  @override
  State<_Bar> createState() => _BarState();
}

class _BarState extends State<_Bar> {
  double _scaleY = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scaleY = 0.92),
      onTapCancel: () => setState(() => _scaleY = 1.0),
      onTapUp: (_) {
        setState(() => _scaleY = 1.0);
        widget.onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.elasticOut,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(blurRadius: 8, offset: Offset(0, 4), color: Colors.black26)],
        ),
        transform: Matrix4.diagonal3Values(1, _scaleY, 1),
        child: Center(
          child: Text(widget.label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
