import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class SongsScreen extends StatefulWidget {
  const SongsScreen({super.key});

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  StateMachineController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cântece')),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // TODO (Răzvan): Înlocuiește cu fundalul scenei de teatru: 'final/fundal_scena.png'.
          Image.asset('assets/images/placeholders/placeholder_landscape.png', fit: BoxFit.cover),

          RiveAnimation.asset(
            'assets/rive/zana_melodia.riv',
            // TODO (Răzvan): Asigură-te că fișierul conține o mașină de stări numită 'ZanaState'.
            onInit: (artboard) {
              try {
                final c = StateMachineController.fromArtboard(artboard, 'ZanaState');
                if (c != null) {
                  artboard.addController(c);
                }
                setState(() => _controller = c);
              } catch (_) {
                // ignora erorile pentru placeholder gol
              }
            },
            fit: BoxFit.contain,
          ),

          Positioned(
            left: 16, right: 16, bottom: 24,
            child: Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _setInput<bool>('isPlaying', true),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Play'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _setInput<bool>('isPlaying', false),
                      icon: const Icon(Icons.pause),
                      label: const Text('Pause'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _fireTrigger('next'),
                      icon: const Icon(Icons.skip_next),
                      label: const Text('Next'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _setInput<T>(String name, T value) {
    final ctrl = _controller;
    if (ctrl == null) return;
    final input = ctrl.findInput<T>(name);
    if (input != null) input.value = value;
  }

  void _fireTrigger(String name) {
    final ctrl = _controller;
    if (ctrl == null) return;
    final input = ctrl.findSMI(name);
    if (input is SMITrigger) {
      input.fire();
    }
  }
}