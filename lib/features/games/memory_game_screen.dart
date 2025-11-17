import 'dart:async';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import '../../services/settings_service.dart';

/// A simple memory matching game.
///
/// Eight cards (four pairs) are laid face down. The player flips over two
/// cards at a time to find matching pairs. When all pairs have been found
/// a success message is shown. The game uses a short delay when two
/// non‑matching cards are revealed before flipping them back.
class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({super.key});

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  final List<IconData> _icons = [
    Icons.star,
    Icons.favorite,
    Icons.lightbulb,
    Icons.pets,
    Icons.music_note,
    Icons.airplanemode_active,
  ];
  late List<IconData> _cards;
  late List<bool> _revealed;
  late List<bool> _matched;
  int? _firstIndex;
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    // Choose number of pairs based on difficulty
    final hardMode = context.read<SettingsService>().hardMode;
    final pairCount = hardMode ? 6 : 4;
    final iconsSubset = _icons.sublist(0, pairCount);
    _cards = List<IconData>.from(iconsSubset)..addAll(iconsSubset);
    _cards.shuffle(Random());
    _revealed = List<bool>.filled(_cards.length, false);
    _matched = List<bool>.filled(_cards.length, false);
    _firstIndex = null;
  }

  void _onCardTap(int index) {
    if (_processing || _matched[index] || _revealed[index]) return;
    setState(() {
      _revealed[index] = true;
    });
    if (_firstIndex == null) {
      _firstIndex = index;
    } else {
      // Compare with first selected
      final first = _firstIndex!;
      if (_cards[first] == _cards[index]) {
        // Match found
        setState(() {
          _matched[first] = true;
          _matched[index] = true;
        });
        _firstIndex = null;
        // Check if game complete
      } else {
        // No match: flip both back after delay
        _processing = true;
        Timer(const Duration(seconds: 1), () {
          setState(() {
            _revealed[first] = false;
            _revealed[index] = false;
          });
          _firstIndex = null;
          _processing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final allMatched = _matched.every((m) => m);
    return Scaffold(
      appBar: AppBar(title: const Text('Memory Game'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: ModelViewer(
                src: 'assets/models/memory/title.glb',
                alt: 'Memory Game Title',
                autoRotate: true,
                autoPlay: true,
                disableZoom: true,
                backgroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 8),
            DefaultTextStyle(
              // headline6 -> titleLarge【259856227738898†L509-L519】.
              style: Theme.of(context).textTheme.titleLarge!,
              child: AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  FadeAnimatedText('Find all the matching pairs!'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _cards.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _onCardTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _matched[index]
                            ? Colors.green.shade200
                            : Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: _revealed[index] || _matched[index]
                            ? Icon(
                                _cards[index],
                                size: 36,
                                color: Colors.black,
                              )
                            : const Icon(Icons.help_outline, size: 36, color: Colors.grey),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (allMatched) ...[
              const SizedBox(height: 16),
              Text(
                'You matched all pairs!',
                // headline5 replaced by headlineSmall【259856227738898†L509-L519】.
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _resetGame();
                  });
                },
                child: const Text('Play Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}