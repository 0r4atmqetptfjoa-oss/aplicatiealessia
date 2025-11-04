import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumea_alessiei/l10n/app_localizations.dart';
import 'package:lumea_alessiei/src/core/data_provider.dart';

// Helper pentru a obține traducerea
String _getTranslatedTitle(BuildContext context, String key) {
  final l10n = AppLocalizations.of(context);
  // Creează cheia de traducere pe baza ID-ului cântecului
  final translationKey = 'song_${key.replaceAll(' ', '_').toLowerCase()}';
  
  // Aici ar trebui să ai o mapare mai robustă sau chei direct în fișierul ARB
  // Pentru moment, facem o verificare simplă.
  if (key == 'Twinkle Twinkle Little Star') {
    return l10n.song_twinkle_twinkle;
  }
  return key; // Fallback
}

class SongsMenuScreen extends ConsumerWidget {
  const SongsMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final data = ref.watch(appDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.menuSongs),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: data.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (appData) {
          final songs = appData.songs['songs'] as List? ?? [];
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/songs_module/background.png"),
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
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                final songId = song['id'] as String? ?? '';
                final titleKey = song['title'] as String? ?? '';

                return ElevatedButton(
                  onPressed: () => context.go('/songs/play/$songId'),
                  child: Text(
                    _getTranslatedTitle(context, titleKey),
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
