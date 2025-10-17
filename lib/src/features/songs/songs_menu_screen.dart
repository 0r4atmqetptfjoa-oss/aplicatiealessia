import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Menu for selecting songs.
///
/// This placeholder screen lists a few sample songs.  The final
/// implementation will load song metadata dynamically from assets.
class SongsMenuScreen extends StatelessWidget {
  const SongsMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final songs = [
      'Melodie 1',
      'Melodie 2',
      'Melodie 3',
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Cântece')),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return ListTile(
            title: Text(song),
            onTap: () {
              // Use GoRouter for navigation
              context.go('/songs/play/${index + 1}');
            },
          );
        },
      ),
    );
  }
}