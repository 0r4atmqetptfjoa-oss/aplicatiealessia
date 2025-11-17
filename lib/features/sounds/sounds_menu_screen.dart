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
          _SoundCategoryTile(
            title: 'Birds',
            path: 'birds',
            assetName: 'birds.png',
          ),
          _SoundCategoryTile(
            title: 'Instruments',
            path: 'category',
            assetName: 'instruments_menu.png',
          ),
          _SoundCategoryTile(
            title: 'Nature',
            path: 'category',
            assetName: 'sounds_menu.png',
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
        if (path == 'birds') {
          context.go('/sounds/birds');
        } else {
          context.go('/sounds/$path');
        }
      },
    );
  }
}