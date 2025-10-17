import 'package:flutter/material.dart';

/// Displays a list of items for a given sound category.
///
/// In the final implementation this screen will show animated buttons
/// with Rive and play the appropriate sound when tapped.  For now it
/// simply shows the category name and placeholder items.
class SoundsDetailScreen extends StatelessWidget {
  final String category;

  const SoundsDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // Placeholder items; real items will come from a data source
    final items = List<String>.generate(10, (index) => 'Item ${index + 1}');
    return Scaffold(
      appBar: AppBar(title: Text('Sunete: $category')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            elevation: 2,
            child: Center(child: Text(item)),
          );
        },
      ),
    );
  }
}