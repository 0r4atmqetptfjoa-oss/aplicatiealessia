import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Displays details of a specific sound category.
/// Screen displaying a list of sounds for a given category.
///
/// The [category] parameter is supplied by the router from the path
/// `/sounds/<category>`. It determines which sounds to display. The
/// category names should match the folder names under
/// `assets/images/sounds/` and `assets/audio/` (e.g. `vehicles`, `farm`).
class SoundCategoryScreen extends StatelessWidget {
  final String category;

  const SoundCategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // Define a map of example sounds per category. In a real application
    // you might load this data from a JSON file or a service. Each
    // sound has a name and optionally a human‑friendly display name. The
    // keys correspond to audio files located in assets/audio/<category>/<sound>.wav
    // and images located in assets/images/sounds/<category>/<sound>.png.
    final Map<String, List<String>> soundsByCategory = {
      'birds': ['sparrow', 'eagle', 'owl'],
      'vehicles': ['car', 'train', 'boat'],
      'farm': ['cow', 'pig', 'chicken'],
      'jungle': ['monkey', 'lion', 'elephant'],
      'maritime': ['ship', 'submarine', 'whale'],
    };

    final sounds = soundsByCategory[category] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(_capitalize(category)),
      ),
      body: sounds.isEmpty
          ? Center(
              child: Text('No sounds configured for $category.'),
            )
          : ListView.builder(
              itemCount: sounds.length,
              itemBuilder: (context, index) {
                final sound = sounds[index];
                return _SoundTile(
                  category: category,
                  soundName: sound,
                );
              },
            ),
    );
  }

  /// Capitalize the first letter of the category for display purposes.
  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}

/// A tile representing an individual sound within a category. When tapped
/// it navigates to the sound detail screen, passing along the category
/// and sound name via the route parameters.
class _SoundTile extends StatelessWidget {
  final String category;
  final String soundName;

  const _SoundTile({required this.category, required this.soundName});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildIcon(),
      title: Text(_capitalize(soundName)),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () {
        context.go('/sounds/$category/$soundName');
      },
    );
  }

  /// Build an icon for the sound. This tries to load an image from
  /// assets/images/sounds/<category>/<sound>.png. If the image is missing,
  /// it displays a default placeholder icon instead. Note: we avoid
  /// using [Image.asset] directly in the build method because missing
  /// assets throw an exception; instead we use [Image.asset] inside a
  /// [Builder] with an error builder.
  Widget _buildIcon() {
    final imagePath = 'assets/images/sounds/$category/$soundName.png';
    return Image.asset(
      imagePath,
      width: 40,
      height: 40,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.image_not_supported);
      },
    );
  }

  /// Capitalize the first letter of the sound name.
  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}