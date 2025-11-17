import 'package:flutter/material.dart';

/// A screen for playing a particular sound.
///
/// In a real application this would load an audio asset and play it when the
/// user presses a button. Here we display a placeholder message.
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

/// Screen that plays a specific sound. The sound file is expected to live
/// under `assets/audio/<category>/<sound>.wav`. The category and sound
/// name are passed via the constructor, typically from the router
/// parameters.
class SoundsDetailScreen extends StatefulWidget {
  final String category;
  final String sound;

  const SoundsDetailScreen({super.key, required this.category, required this.sound});

  @override
  State<SoundsDetailScreen> createState() => _SoundsDetailScreenState();
}

class _SoundsDetailScreenState extends State<SoundsDetailScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      // Construct the asset path. The audio files should be placed at
      // assets/audio/<category>/<sound>.wav. If the file is missing the
      // player will fail silently. Consider adding error handling for
      // production use.
      final assetPath = 'assets/audio/${widget.category}/${widget.sound}.wav';
      await _audioPlayer.play(AssetSource(assetPath));
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayName = _capitalize(widget.sound);
    return Scaffold(
      appBar: AppBar(title: Text(displayName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Illustrative image for the sound. Attempts to load
            // assets/images/sounds/<category>/<sound>.png; falls back to an
            // icon if missing.
            Image.asset(
              'assets/images/sounds/${widget.category}/${widget.sound}.png',
              width: 120,
              height: 120,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.image_not_supported,
                size: 120,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              displayName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _togglePlay,
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
              label: Text(_isPlaying ? 'Pause' : 'Play'),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}