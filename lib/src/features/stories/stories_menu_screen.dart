import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumea_alessiei/l10n/app_localizations.dart';
import 'package:lumea_alessiei/src/core/data_provider.dart';

// Helper pentru a obține traducerea
String _getTranslatedTitle(BuildContext context, String storyId) {
  final l10n = AppLocalizations.of(context);
  switch (storyId) {
    case 'scufita_rosie': return l10n.story_scufita_rosie;
    case 'goldilocks': return l10n.story_goldilocks;
    case 'hansel_gretel': return l10n.story_hansel_gretel;
    case 'three_pigs': return l10n.story_three_pigs;
    case 'cinderella': return l10n.story_cinderella;
    case 'snow_white': return l10n.story_snow_white;
    case 'jack_beanstalk': return l10n.story_jack_beanstalk;
    case 'friendly_dragon': return l10n.story_friendly_dragon;
    case 'rapunzel': return l10n.story_rapunzel;
    case 'pinocchio': return l10n.story_pinocchio;
    case 'sleeping_beauty': return l10n.story_sleeping_beauty;
    case 'thumbelina': return l10n.story_thumbelina;
    case 'puss_in_boots': return l10n.story_puss_in_boots;
    case 'frog_prince': return l10n.story_frog_prince;
    case 'princess_pea': return l10n.story_princess_pea;
    case 'tortoise_hare': return l10n.story_tortoise_hare;
    case 'little_robot': return l10n.story_little_robot;
    case 'magical_rainbow': return l10n.story_magical_rainbow;
    default: return storyId; // Fallback
  }
}

class StoriesMenuScreen extends ConsumerWidget {
  const StoriesMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final data = ref.watch(appDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.menuStories),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: data.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (appData) {
          final stories = appData.stories['stories'] as List? ?? [];
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/stories_module/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: GridView.builder(
              padding: const EdgeInsets.all(24.0),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.0,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: stories.length,
              itemBuilder: (context, index) {
                final story = stories[index];
                final storyId = story['id'] as String? ?? '';

                return ElevatedButton(
                  onPressed: () => context.go('/stories/play/$storyId'),
                  child: Text(
                    _getTranslatedTitle(context, storyId),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
