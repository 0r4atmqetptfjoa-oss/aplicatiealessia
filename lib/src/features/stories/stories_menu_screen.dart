import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Menu for selecting stories.
///
/// Currently this screen lists a few story titles.  The final version
/// will load available stories from assets and display custom icons.
class StoriesMenuScreen extends StatelessWidget {
  const StoriesMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stories = [
      'Scufița Roșie',
      'Capra cu trei iezi',
      'Ileana Cosânzeana',
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Povești')),
      body: ListView.builder(
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          return ListTile(
            title: Text(story),
            onTap: () {
              context.go('/stories/play/${index + 1}');
            },
          );
        },
      ),
    );
  }
}