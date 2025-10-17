import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Menu for selecting sound categories.
///
/// Later this will display icons for farm animals, wild animals, vehicles,
/// marine animals and birds.  Currently it shows a list of the categories
/// as plain text.
class SoundsMenuScreen extends StatelessWidget {
  const SoundsMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Animale de fermă',
      'Animale marine',
      'Vehicule',
      'Animale sălbatice',
      'Păsări',
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Sunete')),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            title: Text(category),
            onTap: () {
              // Navigate to the dynamic category route using GoRouter
              final path = '/sounds/${Uri.encodeComponent(category.toLowerCase())}';
              context.go(path);
            },
          );
        },
      ),
    );
  }
}