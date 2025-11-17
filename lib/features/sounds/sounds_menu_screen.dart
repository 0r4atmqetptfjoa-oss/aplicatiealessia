import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Menu screen listing sound categories.
///
/// This screen displays a few categories of sounds with illustrative icons.
/// Tapping on a category navigates to the appropriate screen. For now only
/// the "Birds" category has a dedicated destination, while the others
/// reuse the generic sound category screen.
class SoundsMenuScreen extends StatelessWidget {
  const SoundsMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sounds')),
      body: ListView(
        children: const [
          // Birds sound category. Place an icon at assets/images/sounds/birds/icon.png
          _SoundCategoryTile(
            title: 'Birds',
            path: 'birds',
            assetName: 'sounds/birds/icon.png',
          ),
          // Vehicles sound category. Place an icon at assets/images/sounds/vehicles/icon.png
          _SoundCategoryTile(
            title: 'Vehicles',
            path: 'vehicles',
            assetName: 'sounds/vehicles/icon.png',
          ),
          // Farm sound category. Place an icon at assets/images/sounds/farm/icon.png
          _SoundCategoryTile(
            title: 'Farm',
            path: 'farm',
            assetName: 'sounds/farm/icon.png',
          ),
          // Jungle sound category. Place an icon at assets/images/sounds/jungle/icon.png
          _SoundCategoryTile(
            title: 'Jungle',
            path: 'jungle',
            assetName: 'sounds/jungle/icon.png',
          ),
          // Maritime sound category. Place an icon at assets/images/sounds/maritime/icon.png
          _SoundCategoryTile(
            title: 'Maritime',
            path: 'maritime',
            assetName: 'sounds/maritime/icon.png',
          ),
        ],
      ),
    );
  }
}

class _SoundCategoryTile extends StatelessWidget {
  final String title;
  final String path;
  final String assetName;
  const _SoundCategoryTile({
    required this.title,
    required this.path,
    required this.assetName,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        'assets/images/$assetName',
        width: 40,
        height: 40,
      ),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () {
        // Navigate to the dynamic category route. The router will handle
        // `/sounds/<category>` and display the appropriate category screen.
        context.go('/sounds/$path');
      },
    );
  }
}