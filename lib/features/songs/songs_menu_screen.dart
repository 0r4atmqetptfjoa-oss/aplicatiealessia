import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Menu screen listing available songs.
///
/// Each song tile shows a small music icon and a play arrow. In the future
/// this screen could dynamically list songs loaded from the network or local
/// storage. Currently it provides three placeholder songs that all link to
/// the same player screen.
class SongsMenuScreen extends StatelessWidget {
  const SongsMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Songs')),
      body: ListView(
        children: const [
          _SongTile(title: 'Song 1'),
          _SongTile(title: 'Song 2'),
          _SongTile(title: 'Song 3'),
        ],
      ),
    );
  }
}

class _SongTile extends StatelessWidget {
  final String title;
  const _SongTile({required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        'assets/images/songs.png',
        width: 40,
        height: 40,
      ),
      title: Text(title),
      trailing: const Icon(Icons.play_arrow),
      onTap: () => context.go('/songs/player'),
    );
  }
}