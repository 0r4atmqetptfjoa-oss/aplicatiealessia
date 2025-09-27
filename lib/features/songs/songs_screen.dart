import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class SongsScreen extends StatefulWidget {
  const SongsScreen({super.key});

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  final _animations = const ['idle', 'dance_slow', 'dance_fast', 'ending_pose'];
  String _current = 'idle';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cântece')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              // TODO (Răzvan): Înlocuiește placeholder-ul cu animația finală Rive `zana_melodia.riv` cu stările menționate în PROMPTS.md
              child: const RiveAnimation.asset(
                'assets/rive/zana_melodia.riv',
                animations: ['idle'],
                fit: BoxFit.contain,
              ),
            ),
          ),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: _animations.map((a) {
              return ElevatedButton(
                onPressed: () => setState(() => _current = a),
                child: Text(a),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
