import 'dart:async';
import 'package:flutter/material.dart';

enum Difficulty { easy, medium, hard }

class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({super.key});

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  late List<GameCard> _cards;
  GameCard? _selectedCard1;
  GameCard? _selectedCard2;
  int _score = 0;
  int _moves = 0;
  Difficulty _difficulty = Difficulty.medium;

  final List<IconData> _allIcons = [
    Icons.star,
    Icons.favorite,
    Icons.anchor,
    Icons.bug_report,
    Icons.camera,
    Icons.directions_bike,
    Icons.emoji_food_beverage,
    Icons.flutter_dash,
    Icons.ac_unit,
    Icons.access_alarm,
    Icons.account_balance,
    Icons.add_a_photo,
  ];

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    _cards = _generateCards();
    _selectedCard1 = null;
    _selectedCard2 = null;
    _score = 0;
    _moves = 0;
    for (var card in _cards) {
      card.isFlipped = false;
      card.isMatched = false;
    }
    setState(() {});
  }

  List<GameCard> _generateCards() {
    int pairCount;
    switch (_difficulty) {
      case Difficulty.easy:
        pairCount = 4;
        break;
      case Difficulty.medium:
        pairCount = 6;
        break;
      case Difficulty.hard:
        pairCount = 8;
        break;
    }
    List<IconData> icons = _allIcons.sublist(0, pairCount);
    List<GameCard> cards = [];
    for (var icon in icons) {
      cards.add(GameCard(icon: icon));
      cards.add(GameCard(icon: icon));
    }
    cards.shuffle();
    return cards;
  }

  void _onCardTapped(GameCard card) {
    if (card.isFlipped || card.isMatched) return;

    setState(() {
      card.isFlipped = true;
    });

    if (_selectedCard1 == null) {
      _selectedCard1 = card;
    } else {
      _selectedCard2 = card;
      _moves++;
      _checkForMatch();
    }
  }

  void _checkForMatch() {
    if (_selectedCard1!.icon == _selectedCard2!.icon) {
      setState(() {
        _selectedCard1!.isMatched = true;
        _selectedCard2!.isMatched = true;
      });
      _selectedCard1 = null;
      _selectedCard2 = null;
      _score++;
      if (_score == _getPairCount()) {
        _showWinDialog();
      }
    } else {
      Timer(const Duration(milliseconds: 500), () {
        setState(() {
          _selectedCard1!.isFlipped = false;
          _selectedCard2!.isFlipped = false;
        });
        _selectedCard1 = null;
        _selectedCard2 = null;
      });
    }
  }

  int _getPairCount() {
    switch (_difficulty) {
      case Difficulty.easy:
        return 4;
      case Difficulty.medium:
        return 6;
      case Difficulty.hard:
        return 8;
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('You Won!'),
        content: Text('You found all the matches in $_moves moves!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount;
    switch (_difficulty) {
      case Difficulty.easy:
        crossAxisCount = 2;
        break;
      case Difficulty.medium:
        crossAxisCount = 3;
        break;
      case Difficulty.hard:
        crossAxisCount = 4;
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Game'),
        actions: [
          PopupMenuButton<Difficulty>(
            onSelected: (Difficulty result) {
              setState(() {
                _difficulty = result;
                _resetGame();
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Difficulty>>[
              const PopupMenuItem<Difficulty>(
                value: Difficulty.easy,
                child: Text('Easy'),
              ),
              const PopupMenuItem<Difficulty>(
                value: Difficulty.medium,
                child: Text('Medium'),
              ),
              const PopupMenuItem<Difficulty>(
                value: Difficulty.hard,
                child: Text('Hard'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Moves: $_moves', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                final card = _cards[index];
                return GestureDetector(
                  onTap: () => _onCardTapped(card),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return RotationYTransition(turns: animation, child: child);
                    },
                    child: Card(
                      key: ValueKey(card.isFlipped),
                      color: card.isMatched ? Colors.green.withOpacity(0.5) : (card.isFlipped ? Colors.white : Colors.blue),
                      child: card.isFlipped
                          ? Icon(card.icon, size: 50)
                          : const SizedBox(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GameCard {
  final IconData icon;
  bool isFlipped = false;
  bool isMatched = false;

  GameCard({required this.icon});
}

class RotationYTransition extends AnimatedWidget {
  const RotationYTransition({
    Key? key,
    required Animation<double> turns,
    this.alignment = Alignment.center,
    required this.child,
  }) : super(key: key, listenable: turns);

  Animation<double> get turns => listenable as Animation<double>;
  final Alignment alignment;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double turnsValue = turns.value;
    final Matrix4 transform = Matrix4.identity()
      ..setEntry(3, 2, 0.001) // perspective
      ..rotateY(pi * turnsValue);
    return Transform(
      transform: transform,
      alignment: alignment,
      child: child,
    );
  }
}
