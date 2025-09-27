import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OrganScreen extends StatelessWidget {
  const OrganScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = getIt<AudioService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Orgă')),
      body: Stack(
        children: [
          // TODO (Răzvan): Înlocuiește cu 'assets/images/final/fundal_orga.png'
          Positioned.fill(
            child: Image.asset('assets/images/placeholders/placeholder_landscape.png', fit: BoxFit.cover),
          ),
          Column(
            children: [
              const SizedBox(height: 12),
              const Text('Glisează sau atinge scoicile!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .scale(curve: Curves.easeOutBack),
              const SizedBox(height: 8),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(5, (i) {
                    final hue = (i * 60).toDouble();
                    final color = HSLColor.fromAHSL(1, hue, 0.6, 0.6).toColor();
                    return Expanded(
                      child: _OrganShell(
                        color: color,
                        label: 'Scoica ${i + 1}',
                        onTap: () => audio.playTap(),
                      ).animate().fadeIn(duration: 300.ms, delay: (i * 80).ms).slideX(begin: 0.1, end: 0),
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrganShell extends StatefulWidget {
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _OrganShell({required this.color, required this.label, required this.onTap});

  @override
  State<_OrganShell> createState() => _OrganShellState();
}

class _OrganShellState extends State<_OrganShell> {
  double _tilt = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (_) => setState(() => _tilt = 0.06),
      onPanEnd: (_) => setState(() => _tilt = 0.0),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        margin: const EdgeInsets.all(6),
        transform: Matrix4.rotationZ(_tilt),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [widget.color, widget.color.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [BoxShadow(blurRadius: 10, offset: Offset(0, 6), color: Colors.black26)],
        ),
        child: Center(
          child: Text(widget.label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
    );
  }
}
