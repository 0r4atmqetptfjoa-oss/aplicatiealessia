import 'package:alesia/games/instruments/drums_game.dart';
import 'package:alesia/games/instruments/organ_game.dart';
import 'package:alesia/games/instruments/piano_game.dart';
import 'package:alesia/games/instruments/xylophone_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GamesMenuScreen extends StatelessWidget {
  const GamesMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Pian Pop', const PianoGame()),
      ('Tobe Pop', const DrumsGame()),
      ('Xilofon Pop', const XylophoneGame()),
      ('Orgă Pop', const OrganGame()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Jocuri')),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final item = items[i];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => Scaffold(
                  appBar: AppBar(title: Text(item.$1)),
                  body: GameWidget(game: item.$2),
                ),
              ));
            },
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Center(child: Text(item.$1, style: const TextStyle(fontWeight: FontWeight.bold))),
            ),
          ).animate().fadeIn(duration: 300.ms, delay: (i * 80).ms).scale(curve: Curves.easeOutBack);
        },
      ),
    );
  }
}
