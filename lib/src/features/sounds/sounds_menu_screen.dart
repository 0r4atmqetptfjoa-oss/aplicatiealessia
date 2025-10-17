import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/data_provider.dart';

class SoundsMenuScreen extends ConsumerWidget {
  const SoundsMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(appDataProvider);

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
      body: data.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (appData) {
          final categories = appData.sounds['categories'] as List;
          return GridView.builder(
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
                category: _Category(
                  key: category['id'],
                  label: category['name'],
                  iconPath: 'assets/images/sounds_module/categories/${category['id']}.png',
                ),
                onTap: () {
                  context.go('/sounds/${category['id']}');
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _Category {
  final String key;
  final String label;
  final String iconPath;

  const _Category({required this.key, required this.label, required this.iconPath});
}

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
