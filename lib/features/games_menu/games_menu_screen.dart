import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class GamesMenuScreen extends StatelessWidget {
  const GamesMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = [
      {'title': 'Instrumente', 'route': '/instrumente', 'asset': 'menu_instrumente.png'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Jocuri')),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final e = entries[index];
          return Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              onTap: () => GoRouter.of(context).push(e['route']!),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox.square(
                  dimension: 56,
                  // TODO (Răzvan): Înlocuiește cu previzualizarea finală:
                  child: Image.asset('assets/images/placeholders/placeholder_square.png', fit: BoxFit.cover),
                ),
              ),
              title: Text(e['title']!),
              trailing: const Icon(Icons.chevron_right),
            ),
          ).animate().fadeIn().slideX(begin: 0.1, curve: Curves.easeOut);
        },
      ),
    );
  }
}
