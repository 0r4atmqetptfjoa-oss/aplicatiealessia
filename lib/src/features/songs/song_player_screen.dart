import 'package:flutter/material.dart';

/// Plays a selected song.
///
/// This placeholder shows the songId in the UI.  The final version
/// will play audio and show an animated video in sync.
class SongPlayerScreen extends StatelessWidget {
  final String songId;
  const SongPlayerScreen({super.key, required this.songId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Redare Cântec')), 
      body: Center(
        child: Text('Reproduceri: $songId'),
      ),
    );
  }
}