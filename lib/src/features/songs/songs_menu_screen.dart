import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart';

class _SongItem {
  final String id;
  final String title;
  final String artboard;
  const _SongItem({required this.id, required this.title, required this.artboard});
}

class SongsMenuScreen extends StatelessWidget {
  const SongsMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_SongItem> songs = [
      const _SongItem(id: 'melodie_1', title: 'Melodie 1', artboard: 'BTN_MELODIE_1'),
      // Add more songs here
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cântece'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => context.go('/home'),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/songs_module/background.png"), // Placeholder background
            fit: BoxFit.cover,
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 24,
            crossAxisSpacing: 24,
            childAspectRatio: 1.0,
          ),
          itemCount: songs.length,
          itemBuilder: (context, index) {
            final song = songs[index];
            return _SongButton(
              artboard: song.artboard,
              onTap: () => context.go('/songs/play/${song.id}'),
            );
          },
        ),
      ),
    );
  }
}

class _SongButton extends StatelessWidget {
  final String artboard;
  final VoidCallback onTap;

  const _SongButton({required this.artboard, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: RiveAnimation.asset(
            'assets/rive/song_buttons.riv',
            artboard: artboard,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
