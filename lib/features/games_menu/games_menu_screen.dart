import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class GamesMenuScreen extends StatelessWidget {
  const GamesMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final games = [
      {'title': 'Pian', 'route': '/instrumente/pian'},
      {'title': 'Tobe', 'route': '/instrumente/tobe'},
      {'title': 'Xilofon', 'route': '/instrumente/xilofon'},
      {'title': 'Orgă', 'route': '/instrumente/orga'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Jocuri')),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemCount: games.length,
        itemBuilder: (context, index) {
          final g = games[index];
          return ListTile(
            onTap: () => GoRouter.of(context).push(g['route']!),
            tileColor: Colors.deepPurple.shade50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(g['title']!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.chevron_right),
          ).animate().fade(duration: 400.ms).slideX(begin: 0.1).scale(delay: (index * 80).ms);
        },
      ),
    );
  }
}
