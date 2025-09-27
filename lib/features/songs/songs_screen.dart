import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rive/rive.dart';

class SongsScreen extends StatefulWidget {
  const SongsScreen({super.key});

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  bool _riveAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkRive();
  }

  Future<void> _checkRive() async {
    try {
      final ByteData data = await rootBundle.load('assets/rive/zana_melodia.riv');
      if (data.lengthInBytes > 0) {
        setState(() => _riveAvailable = true);
      }
    } catch (_) {
      setState(() => _riveAvailable = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cântece')),
      body: Stack(
        children: [
          // TODO (Răzvan): Înlocuiește placeholder-ul cu 'fundal_scena.png'
          Positioned.fill(child: Image.asset('assets/images/placeholders/placeholder_landscape.png', fit: BoxFit.cover)),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: 400.ms,
                  child: _riveAvailable
                      ? const SizedBox(
                          key: ValueKey('rive'),
                          height: 320,
                          width: 320,
                          child: RiveAnimation.asset(
                            // TODO (Răzvan): Înlocuiește cu animația finală + numele animației de start (ex. 'idle')
                            'assets/rive/zana_melodia.riv',
                            animations: ['idle'],
                            fit: BoxFit.contain,
                          ),
                        )
                      : SizedBox(
                          key: const ValueKey('ph'),
                          height: 320,
                          width: 320,
                          // TODO (Răzvan): Înlocuiește cu o ilustrație a scenei muzicale
                          child: Image.asset('assets/images/placeholders/placeholder_square.png'),
                        ),
                ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.9, 0.9)),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () {},
                  child: const Text('Redă melodia demonstrativă'),
                ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(duration: 800.ms, begin: const Offset(0.98, 0.98), end: const Offset(1.02, 1.02)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}