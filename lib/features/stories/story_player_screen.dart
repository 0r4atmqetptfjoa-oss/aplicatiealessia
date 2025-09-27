import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StoryPlayerScreen extends StatelessWidget {
  const StoryPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = List.generate(3, (i) => i);

    return Scaffold(
      appBar: AppBar(title: const Text('Povești')),
      body: Stack(
        children: [
          // TODO (Răzvan): Înlocuiește cu un fundal ilustrat: 'assets/images/final/story_bg.png'
          Positioned.fill(
            child: Image.asset('assets/images/placeholders/placeholder_landscape.png', fit: BoxFit.cover),
          ),
          PageView.builder(
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: Stack(
                    children: [
                      // TODO (Răzvan): Înlocuiește cu ilustrația paginii: 'assets/images/final/story_page_$index.png'
                      Positioned.fill(
                        child: Image.asset('assets/images/placeholders/placeholder_square.png', fit: BoxFit.cover),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('Pagina ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms).scale(curve: Curves.easeOutBack),
              );
            },
          ),
        ],
      ),
    );
  }
}
