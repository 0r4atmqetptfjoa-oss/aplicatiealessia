import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/story.dart';

/// Menu screen listing available stories.
///
/// This widget displays a list of stories defined in memory. Each story
/// contains a title, a list of image assets and an audio narration. When
/// tapping on a story the user is navigated to the player screen with the
/// selected [Story] passed as extra data via GoRouter. Add new stories by
/// extending the `_stories` list with additional [Story] instances.
class StoriesMenuScreen extends StatelessWidget {
  const StoriesMenuScreen({super.key});

  /// Example stories bundled with the app. Each entry provides a title,
  /// associated images and an audio file. In a real application these could
  /// be loaded from a JSON manifest or remote API.
  static final List<Story> _stories = [
    Story(
      title: 'The Brave Little Train',
      imagePaths: [
        'assets/stories/train_1.png',
        'assets/stories/train_2.png',
        'assets/stories/train_3.png',
      ],
      audioPath: 'assets/audio/story1.wav',
    ),
    Story(
      title: 'The Curious Kitten',
      imagePaths: [
        'assets/stories/kitten_1.png',
        'assets/stories/kitten_2.png',
        'assets/stories/kitten_3.png',
      ],
      audioPath: 'assets/audio/story2.wav',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stories')),
      body: ListView.builder(
        itemCount: _stories.length,
        itemBuilder: (context, index) {
          final story = _stories[index];
          return ListTile(
            leading: Image.asset(
              'assets/images/stories.png',
              width: 40,
              height: 40,
            ),
            title: Text(story.title),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => context.go(
              '/stories/player',
              extra: story,
            ),
          );
        },
      ),
    );
  }
}