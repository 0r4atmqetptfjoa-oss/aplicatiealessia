import 'package:flutter/material.dart';

/// A simple song player screen.
///
/// In a full application this would integrate an audio player such as just_audio
/// or audio_service. For now it displays placeholder text.
class SongPlayerScreen extends StatelessWidget {
  const SongPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Song Player')),
      body: const Center(
        child: Text('Song player will be implemented here.'),
      ),
    );
  }
}