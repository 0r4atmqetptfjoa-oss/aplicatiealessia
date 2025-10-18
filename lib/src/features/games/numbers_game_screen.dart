import 'package:flutter/material.dart';
import 'dart:math';

class NumbersGameScreen extends StatefulWidget {
  const NumbersGameScreen({super.key});

  @override
  State<NumbersGameScreen> createState() => _NumbersGameScreenState();
}

class _NumbersGameScreenState extends State<NumbersGameScreen> {
  late int _targetNumber;
  late List<bool> _tappedObjects;
  int _currentCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    final random = Random();
    _targetNumber = random.nextInt(9) + 1; // 1 to 9
    _tappedObjects = List.generate(_targetNumber, (_) => false);
    _currentCount = 0;
  }

  void _onObjectTapped(int index) {
    if (!_tappedObjects[index]) {
      setState(() {
        _tappedObjects[index] = true;
        _currentCount++;
      });

      // Play a sound for the number
      // audioService.play('assets/audio/numbers/$_currentCount.wav');

      if (_currentCount == _targetNumber) {
        _showSuccessDialog();
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excellent!'),
        content: Text('You counted to $_targetNumber!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
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
      appBar: AppBar(title: const Text('Counting Game')),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Count the objects: $_currentCount / $_targetNumber',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GridView.builder(
              padding: const EdgeInsets.all(24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
              ),
              itemCount: _targetNumber,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _onObjectTapped(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _tappedObjects[index] ? Colors.green.shade200 : Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      // Replace with an actual image/icon
                      child: Icon(
                        _tappedObjects[index] ? Icons.check_circle : Icons.star,
                        size: 48,
                        color: Colors.white,
                      ),
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
