import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Model representing a memory card.
class _MemoryCard {
  _MemoryCard({required this.imagePath});

  final String imagePath;
  bool isFlipped = false;
  bool isMatched = false;
}

/// A cute memory matching game using Pixar‑style icons.
///
/// The child flips two cards at a time trying to find matching pairs.  When
/// all pairs are matched, a simple congratulations message is shown.
class MemoryScreen extends StatefulWidget {
  const MemoryScreen({super.key});

  @override
  State<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen> {
  late List<_MemoryCard> _cards;
  int? _firstIndex;
  int? _secondIndex;
  bool _waiting = false;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _initGame();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  void _initGame() {
    final List<String> images = [
      'assets/images/games/memory/pig.png',
      'assets/images/games/memory/cow.png',
      'assets/images/games/memory/elephant.png',
      'assets/images/games/memory/car.png',
    ];
    _cards = images
        .expand((path) => [_MemoryCard(imagePath: path), _MemoryCard(imagePath: path)])
        .toList();
    _cards.shuffle(Random());
    _firstIndex = null;
    _secondIndex = null;
    _waiting = false;
    _completed = false;
  }

  void _onCardTap(int index) {
    if (_waiting) return;
    final card = _cards[index];
    if (card.isMatched || card.isFlipped) return;
    setState(() {
      card.isFlipped = true;
      if (_firstIndex == null) {
        _firstIndex = index;
      } else {
        _secondIndex = index;
        _waiting = true;
        _checkMatch();
      }
    });
  }

  void _checkMatch() {
    if (_firstIndex == null || _secondIndex == null) return;
    final firstCard = _cards[_firstIndex!];
    final secondCard = _cards[_secondIndex!];
    if (firstCard.imagePath == secondCard.imagePath) {
      // Match found
      setState(() {
        firstCard.isMatched = true;
        secondCard.isMatched = true;
        _resetSelection();
        _waiting = false;
        // Check completion
        if (_cards.every((c) => c.isMatched)) {
          _completed = true;
        }
      });
    } else {
      // No match; flip back after delay
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          firstCard.isFlipped = false;
          secondCard.isFlipped = false;
          _resetSelection();
          _waiting = false;
        });
      });
    }
  }

  void _resetSelection() {
    _firstIndex = null;
    _secondIndex = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memorie'),
        leading: BackButton(onPressed: () => Navigator.of(context).pop()),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => _initGame());
            },
          ),
        ],
      ),
      body: _completed
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Bravo! Ai găsit toate perechile!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() => _initGame()),
                    child: const Text('Joacă din nou'),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                itemCount: _cards.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final card = _cards[index];
                  return GestureDetector(
                    onTap: () => _onCardTap(index),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: card.isFlipped || card.isMatched
                          ? Container(
                              key: ValueKey('face$index'),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Image.asset(card.imagePath),
                              ),
                            )
                          : Container(
                              key: ValueKey('back$index'),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(12),
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF6EC6FF), Color(0xFF2196F3)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}