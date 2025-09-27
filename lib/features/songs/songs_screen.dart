import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rive/rive.dart';

class SongsScreen extends StatefulWidget {
  const SongsScreen({super.key});

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  Artboard? _artboard;
  RiveAnimationController<dynamic>? _controller;
  bool _riveFailed = false;

  @override
  void initState() {
    super.initState();
    _loadRive();
  }

  Future<void> _loadRive() async {
    try {
      // TODO (Răzvan): Înlocuiește placeholder-ul cu animația reală `assets/rive/zana_melodia.riv`
      final ByteData data = await rootBundle.load('assets/rive/zana_melodia.riv');
      final file = RiveFile.import(data.buffer.asUint8List());
      final artboard = file.mainArtboard;
      _controller = SimpleAnimation('idle');
      artboard.addController(_controller!);
      setState(() => _artboard = artboard);
    } catch (_) {
      setState(() => _riveFailed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cântece')),
      body: Stack(
        children: [
          // TODO (Răzvan): Înlocuiește cu 'assets/images/final/fundal_scena.png'
          Positioned.fill(
            child: Image.asset('assets/images/placeholders/placeholder_landscape.png', fit: BoxFit.cover),
          ),
          Center(
            child: _artboard != null && !_riveFailed
                ? SizedBox(
                    width: 320,
                    height: 320,
                    child: Rive(artboard: _artboard!),
                  ).animate().fadeIn(duration: 350.ms).scale(curve: Curves.easeOutBack)
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // TODO (Răzvan): Înlocuiește cu un PNG al zânei din /final dacă dorești fallback vizual.
                      Image.asset('assets/images/placeholders/placeholder_square.png', width: 200, height: 200),
                      const SizedBox(height: 12),
                      const Text(
                        'Zâna Melodia: adaugă fișierul .riv pentru animație',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ).animate().fadeIn(duration: 300.ms),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SongButton(text: 'Dans lent', onPressed: () => _play('dance_slow')),
                const SizedBox(width: 12),
                _SongButton(text: 'Dans rapid', onPressed: () => _play('dance_fast')),
                const SizedBox(width: 12),
                _SongButton(text: 'Încheiere', onPressed: () => _play('ending_pose')),
              ],
            ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutBack),
          ),
        ],
      ),
    );
  }

  void _play(String name) {
    if (_artboard == null) return;
    _artboard!.removeController(_controller!);
    _controller = SimpleAnimation(name);
    _artboard!.addController(_controller!);
  }
}

class _SongButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _SongButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
