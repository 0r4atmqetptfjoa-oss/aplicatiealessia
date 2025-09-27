import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class InstrumentsMenuScreen extends StatelessWidget {
  const InstrumentsMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final instruments = [
      {'name': 'Pian', 'asset': 'preview_pian.png', 'route': '/instrumente/pian'},
      {'name': 'Tobe', 'asset': 'preview_tobe.png', 'route': '/instrumente/tobe'},
      {'name': 'Xilofon', 'asset': 'preview_xilofon.png', 'route': '/instrumente/xilofon'},
      {'name': 'Orgă', 'asset': 'preview_orga.png', 'route': '/instrumente/orga'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Instrumente')),
      body: GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: instruments.length,
        itemBuilder: (context, index) {
          final instrument = instruments[index];
          return GestureDetector(
            onTap: () => GoRouter.of(context).push(instrument['route']!),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.grey.shade300,
                      // TODO (Răzvan): Înlocuiește placeholder-ul cu resursa finală:
                      // child: Image.asset('assets/images/final/${instrument['asset']}', fit: BoxFit.cover),
                      child: Image.asset('assets/images/placeholders/placeholder_square.png', fit: BoxFit.cover),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(instrument['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                ],
              ),
            ),
          ).animate().fade(duration: 500.ms).scale(delay: (100 * index).ms);
        },
      ),
    );
  }
}
