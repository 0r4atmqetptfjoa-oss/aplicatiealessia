import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A data model describing a song item.
class _SongItem {
  final String id;
  final String title;
  final String imageAsset;
  const _SongItem({required this.id, required this.title, required this.imageAsset});
}

/// Menu for selecting songs.
///
/// Displays a list of available songs loaded from the assets folder.  Each
/// entry shows a thumbnail and the song title.  Tapping a song navigates
/// to the player screen where the audio and associated animation loop are
/// played simultaneously.
class SongsMenuScreen extends StatelessWidget {
  const SongsMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define available songs.  In a later phase this could be loaded
    // dynamically by scanning the assets directory or via a configuration
    // file.  For now we explicitly list the test placeholder.
    final List<_SongItem> songs = [
      const _SongItem(
        id: 'melodie_1',
        title: 'Melodie 1',
        imageAsset: 'assets/images/songs_module/melodie_1.png',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Cântece')),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return ListTile(
            leading: Image.asset(
              song.imageAsset,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
            title: Text(song.title),
            trailing: const Icon(Icons.play_arrow),
            onTap: () {
              context.go('/songs/play/${song.id}');
            },
          );
        },
      ),
    );
  }
}