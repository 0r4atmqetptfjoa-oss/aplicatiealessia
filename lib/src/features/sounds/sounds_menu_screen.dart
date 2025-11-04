import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumea_alessiei/l10n/app_localizations.dart';
import 'package:lumea_alessiei/src/core/data_provider.dart';

// Helper pentru a obține traducerea unui titlu de categorie
String _getTranslatedCategoryTitle(BuildContext context, String key) {
  final l10n = AppLocalizations.of(context);
  switch (key) {
    case 'categoryFarm': return l10n.categoryFarm;
    case 'categoryWild': return l10n.categoryWild;
    case 'categoryMarine': return l10n.categoryMarine;
    case 'categoryBirds': return l10n.categoryBirds;
    case 'categoryVehicles': return l10n.categoryVehicles;
    default: return key; // Fallback
  }
}

class SoundsMenuScreen extends ConsumerWidget {
  const SoundsMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final data = ref.watch(appDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.menuSounds),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: data.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (appData) {
          final categories = (appData.sounds['categories'] as List?)?.cast<Map<String, dynamic>>() ?? [];
          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250.0,
                childAspectRatio: 1.0,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final categoryId = category['id'] as String;
              final titleKey = category['title'] as String;

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: InkWell(
                  onTap: () => context.go('/sounds/$categoryId'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset('assets/images/sounds_module/categories/$categoryId.png'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          _getTranslatedCategoryTitle(context, titleKey),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
