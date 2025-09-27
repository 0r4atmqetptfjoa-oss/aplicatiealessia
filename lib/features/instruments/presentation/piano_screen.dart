import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PianoScreen extends StatelessWidget {
  const PianoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = getIt<AudioService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Pian')),
      body: Stack(
        children: [
          // TODO (Răzvan): Înlocuiește cu 'assets/images/final/fundal_pian.png'
          Positioned.fill(
            child: Image.asset(
              'assets/images/placeholders/placeholder_landscape.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 12),
              const Text('Atinge clapele!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .scale(curve: Curves.easeOutBack),
              const SizedBox(height: 8),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final keyCount = 7;
                    final keyWidth = constraints.maxWidth / keyCount;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List.generate(keyCount, (i) {
                        final color = Colors.primaries[i % Colors.primaries.length].shade300;
                        return _SquashyKey(
                          width: keyWidth,
                          label: String.fromCharCode(65 + i), // A, B, C...
                          color: color,
                          onTap: () => audio.playTap(),
                        );
                      }),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }
}

class _SquashyKey extends StatefulWidget {
  final double width;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SquashyKey({
    required this.width,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_SquashyKey> createState() => _SquashyKeyState();
}

class _SquashyKeyState extends State<_SquashyKey> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.94),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOut,
        child: Container(
          width: widget.width,
          margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 10),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(blurRadius: 8, offset: Offset(0, 4), color: Colors.black26),
            ],
          ),
          child: Center(
            child: Text(
              widget.label,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
             .scale(duration: 1200.ms, curve: Curves.easeInOut, begin: const Offset(1,1), end: const Offset(1.06,1.06)),
          ),
        ),
      ),
    );
  }
}
