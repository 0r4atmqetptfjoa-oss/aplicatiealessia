import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumea_alessiei/l10n/app_localizations.dart';
import '../../core/widgets/rive_button.dart';
import '../../core/data_provider.dart';

class StoriesMenuScreen extends ConsumerWidget {
  const StoriesMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final data = ref.watch(appDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.menuStories),
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
      body: data.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (appData) {
          final stories = appData.stories['stories'] as List;
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/stories_module/background.png"), // Placeholder
                fit: BoxFit.cover,
              ),
            ),
            child: GridView.builder(
              padding: const EdgeInsets.all(24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
              ),
              itemCount: stories.length,
              itemBuilder: (context, index) {
                final story = stories[index];
                return RiveButton(
                  riveAsset: 'assets/rive/story_buttons.riv',
                  artboardName: story['artboard']!,
                  stateMachineName: 'State Machine 1', // Assuming a consistent state machine name
                  onTap: () => context.go('/stories/play/${story['id']}'),
                  label: l10n.lookup(story['title']!) ?? story['title']!,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
