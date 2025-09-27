import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DrumsScreen extends StatelessWidget {
  const DrumsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = getIt<AudioService>();
    final pads = [
      Colors.red.shade300,
      Colors.blue.shade300,
      Colors.green.shade300,
      Colors.orange.shade300,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Tobe')),
      body: Stack(
        children: [
          // TODO (Răzvan): Înlocuiește cu 'assets/images/final/fundal_tobe.png'
          Positioned.fill(
            child: Image.asset('assets/images/placeholders/placeholder_landscape.png', fit: BoxFit.cover),
          ),
          GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: pads.length,
            itemBuilder: (context, i) {
              return _DrumPad(
                color: pads[i],
                label: 'Pad ${i + 1}',
                onTap: () => audio.playTap(),
              ).animate().fadeIn(duration: 300.ms, delay: (i * 100).ms).scale(curve: Curves.easeOutBack);
            },
          ),
        ],
      ),
    );
  }
}

class _DrumPad extends StatefulWidget {
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _DrumPad({required this.color, required this.label, required this.onTap});

  @override
  State<_DrumPad> createState() => _DrumPadState();
}

class _DrumPadState extends State<_DrumPad> {
  double _scale = 1.0;
  double _opacity = 0.0;

  void _pulse() async {
    setState(() => _opacity = 0.6);
    await Future.delayed(const Duration(milliseconds: 220));
    if (mounted) setState(() => _opacity = 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.92),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        _pulse();
        widget.onTap();
      },
      child: Stack(
        children: [
          AnimatedScale(
            scale: _scale,
            duration: const Duration(milliseconds: 90),
            curve: Curves.easeOut,
            child: Container(
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(26),
                boxShadow: const [BoxShadow(blurRadius: 12, offset: Offset(0, 6), color: Colors.black26)],
              ),
              child: Center(
                child: Text(widget.label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ),
          // "Ring pulse" efect
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(milliseconds: 180),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: Colors.white, width: 6),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
