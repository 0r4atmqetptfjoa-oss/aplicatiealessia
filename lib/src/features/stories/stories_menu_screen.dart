import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumea_alessiei/l10n/app_localizations.dart';
import '../../core/widgets/rive_button.dart';
import '../../core/data_provider.dart';

class StoriesMenuScreen extends ConsumerWidget {
  const StoriesMenuScreen({super.key});

  String _getStoryTitle(AppLocalizations? l10n, String titleKey) {
    if (l10n == null) return titleKey;
    switch (titleKey) {
      case 'storyRedRidingHood':
        return l10n.storyRedRidingHood;
      default:
        return titleKey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final data = ref.watch(appDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.menuStories ?? 'Stories'),
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
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage("assets/images/stories_module/background.png"),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  // Don't crash if the background is missing
                },
              ),
            ),
            child: GridView.extent(
              maxCrossAxisExtent: 300.0,
              padding: const EdgeInsets.all(24),
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              children: stories.map((story) {
                final artboard = story['artboard'] as String? ?? 'UNKNOWN';
                final storyId = story['id'] as String? ?? '';
                final titleKey = story['title'] as String? ?? '';

                return RiveButton(
                  riveAsset: 'assets/rive/story_buttons.riv',
                  artboardName: artboard,
                  stateMachineName: 'State Machine 1',
                  onTap: () => context.go('/stories/play/$storyId'),
                  label: _getStoryTitle(l10n, titleKey),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
