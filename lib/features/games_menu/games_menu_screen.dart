import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class GamesMenuScreen extends StatelessWidget {
  const GamesMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tiles = [
      {'title': 'Pian', 'route': '/instrumente/pian', 'asset': 'preview_pian.png'},
      {'title': 'Tobe', 'route': '/instrumente/tobe', 'asset': 'preview_tobe.png'},
      {'title': 'Xilofon', 'route': '/instrumente/xilofon', 'asset': 'preview_xilofon.png'},
      {'title': 'Orgă', 'route': '/instrumente/orga', 'asset': 'preview_orga.png'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Jocuri')),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: tiles.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, i) {
          final t = tiles[i];
          return InkWell(
            onTap: () => GoRouter.of(context).push(t['route']!),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      // TODO (Răzvan): Înlocuiește cu resursa finală '${t['asset']}'.
                      child: Image.asset('assets/images/placeholders/placeholder_square.png', fit: BoxFit.cover),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(t['title']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
          ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.98, 0.98));
        },
      ),
    );
  }
}
