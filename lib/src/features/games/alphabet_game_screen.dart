import 'package:flutter/material.dart';
import 'dart:math';

class AlphabetGameScreen extends StatefulWidget {
  const AlphabetGameScreen({super.key});

  @override
  State<AlphabetGameScreen> createState() => _AlphabetGameScreenState();
}

class _AlphabetGameScreenState extends State<AlphabetGameScreen> {
  late List<String> _letters;
  late Map<String, String> _targets;
  late String _currentTargetLetter;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    final allLetters = List.generate(26, (index) => String.fromCharCode('A'.codeUnitAt(0) + index));
    final random = Random();
    _letters = (allLetters..shuffle(random)).take(4).toList();
    
    // Simple mapping for demo purposes
    final allTargets = {
      'A': 'Apple', 'B': 'Ball', 'C': 'Cat', 'D': 'Dog',
      'E': 'Elephant', 'F': 'Fish', 'G': 'Goat', /* ... add more */
    };
    
    _targets = { for (var letter in _letters) letter: allTargets[letter] ?? 'Object' };
    _currentTargetLetter = _letters[random.nextInt(_letters.length)];
  }

  void _onLetterDropped(String letter, String target) {
    if (letter == target) {
      setState(() {
        _score++;
        _letters.remove(letter);
        if (_letters.isEmpty) {
          // Game over or next level
          _showGameOverDialog();
        } else {
          _currentTargetLetter = _letters[Random().nextInt(_letters.length)];
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Try again!'), duration: Duration(seconds: 1)),
      );
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Congratulations!'),
        content: Text('You finished the level with a score of $_score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _score = 0;
                _initializeGame();
              });
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alphabet Game')),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Text('Find the object for: $_currentTargetLetter', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _targets.entries.map((entry) {
                return DragTarget<String>(
                  builder: (context, candidateData, rejectedData) {
                    return _TargetObject(objectName: entry.value);
                  },
                  onAcceptWithDetails: (details) => _onLetterDropped(details.data, entry.key),
                );
              }).toList(),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _letters.map((letter) => _DraggableLetter(letter: letter)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DraggableLetter extends StatelessWidget {
  final String letter;
  const _DraggableLetter({required this.letter});

  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: letter,
      feedback: Material(
        color: Colors.transparent,
        child: Text(letter, style: const TextStyle(fontSize: 48, color: Colors.blue, fontWeight: FontWeight.bold)),
      ),
      childWhenDragging: Container(width: 60, height: 60, color: Colors.grey.shade300),
      child: Container(
        width: 60,
        height: 60,
        color: Colors.blue.shade100,
        child: Center(child: Text(letter, style: const TextStyle(fontSize: 32))),
      ),
    );
  }
}

class _TargetObject extends StatelessWidget {
  final String objectName;
  const _TargetObject({required this.objectName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(child: Text(objectName, style: const TextStyle(fontSize: 18))),
    );
  }
}
