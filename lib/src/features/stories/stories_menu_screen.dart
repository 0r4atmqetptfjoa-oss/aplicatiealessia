import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart';

class _StoryItem {
  final String id;
  final String title;
  final String artboard;
  const _StoryItem({required this.id, required this.title, required this.artboard});
}

class StoriesMenuScreen extends StatelessWidget {
  const StoriesMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_StoryItem> stories = [
      const _StoryItem(id: 'scufita_rosie', title: 'Scufița Roșie', artboard: 'BTN_SCUFITA_ROSIE'),
      // Add more stories here
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/stories_module/background.png"), // Placeholder background
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
          itemCount: stories.length,
          itemBuilder: (context, index) {
            final story = stories[index];
            return _StoryButton(
              artboard: story.artboard,
              onTap: () => context.go('/stories/play/${story.id}'),
            );
          },
        ),
      ),
    );
  }
}

class _StoryButton extends StatelessWidget {
  final String artboard;
  final VoidCallback onTap;

  const _StoryButton({required this.artboard, required this.onTap});

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
            'assets/rive/story_buttons.riv',
            artboard: artboard,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
