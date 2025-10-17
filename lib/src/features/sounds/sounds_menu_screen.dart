import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Menu for selecting sound categories.
///
/// Later this will display icons for farm animals, wild animals, vehicles,
/// marine animals and birds.  Currently it shows a list of the categories
/// as plain text.

/// Screen that lists the available sound categories.
///
/// Each category is represented by an icon and a label.  When the user
/// taps on a category, they are navigated to the detail screen for that
/// category.  A home button and a back button are provided in the
/// app bar for navigation.  The actual image files referenced here
/// (e.g. `assets/images/sounds_module/ferma.png`) must be supplied by
/// the asset author.  See the `assets` section of `pubspec.yaml`.
class SoundsMenuScreen extends StatelessWidget {
  const SoundsMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the categories with their identifiers, labels and icon paths.
    // The keys should match the route segment used in GoRouter (e.g. /sounds/ferma).
    final categories = <_Category>[
      _Category(
        key: 'ferma',
        label: 'Animale de fermă',
        // Use the category icons stored under assets/images/sounds_module/categories
        iconPath: 'assets/images/sounds_module/categories/ferma.png',
      ),
      _Category(
        key: 'marine',
        label: 'Animale marine',
        iconPath: 'assets/images/sounds_module/categories/marine.png',
      ),
      _Category(
        key: 'vehicule',
        label: 'Vehicule',
        iconPath: 'assets/images/sounds_module/categories/vehicule.png',
      ),
      _Category(
        key: 'salbatice',
        label: 'Animale sălbatice',
        iconPath: 'assets/images/sounds_module/categories/salbatice.png',
      ),
      _Category(
        key: 'pasari',
        label: 'Păsări',
        iconPath: 'assets/images/sounds_module/categories/pasari.png',
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sunete'),
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
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.0,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _CategoryCard(
            category: category,
            onTap: () {
              // Navigate to the dynamic category route using GoRouter.
              context.go('/sounds/${category.key}');
            },
          );
        },
      ),
    );
  }
}

/// Internal model representing a sound category.
class _Category {
  final String key;
  final String label;
  final String iconPath;

  const _Category({required this.key, required this.label, required this.iconPath});
}

/// A card widget that displays a category icon and label.
class _CategoryCard extends StatelessWidget {
  final _Category category;
  final VoidCallback onTap;

  const _CategoryCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  category.iconPath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                category.label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}