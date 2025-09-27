import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class GamesMenuScreen extends StatelessWidget {
  const GamesMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'title': 'Instrumente', 'subtitle': 'Pian, Tobe, Xilofon, Orgă', 'route': '/instrumente'},
      {'title': 'Cântece', 'subtitle': 'Zâna Melodia', 'route': '/canciones'},
      {'title': 'Harta Sunetelor', 'subtitle': 'Ferma, Junglă, Oraș', 'route': '/sunete'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Jocuri & Activități')),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final it = items[i];
          return ListTile(
            onTap: () => GoRouter.of(context).push(it['route']!),
            title: Text(it['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(it['subtitle']!),
            trailing: const Icon(Icons.chevron_right),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            tileColor: Colors.deepPurple.withOpacity(0.05),
          ).animate().fadeIn(duration: 400.ms, delay: (i * 100).ms).moveX(begin: 20, end: 0, duration: 400.ms);
        },
      ),
    );
  }
}