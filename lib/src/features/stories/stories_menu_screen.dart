import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router/go_router.dart';

/// A data model describing a story item.
class _StoryItem {
  final String id;
  final String title;
  final String imageAsset;
  const _StoryItem({required this.id, required this.title, required this.imageAsset});
}

/// Menu for selecting stories.
///
/// Displays a list of available stories loaded from the assets folder.  Each
/// entry shows a thumbnail and the story title.  Tapping a story navigates
/// to the player screen where the full narrated video plays.
class StoriesMenuScreen extends StatelessWidget {
  const StoriesMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define available stories.  This could be loaded dynamically in a
    // future phase by scanning the assets directory.  For now we include
    // the placeholder story Scufița Roșie.
    final List<_StoryItem> stories = [
      const _StoryItem(
        id: 'scufita_rosie',
        title: 'Scufița Roșie',
        imageAsset: 'assets/images/stories_module/scufita_rosie.png',
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Povești'),
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
      body: ListView.builder(
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          return ListTile(
            leading: Image.asset(
              story.imageAsset,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
            title: Text(story.title),
            trailing: const Icon(Icons.play_arrow),
            onTap: () {
              context.go('/stories/play/${story.id}');
            },
          );
        },
      ),
    );
  }
}