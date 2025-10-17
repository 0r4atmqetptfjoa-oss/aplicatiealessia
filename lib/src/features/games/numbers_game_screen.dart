import 'package:flutter/material.dart';

/// Placeholder screen for the Numbers game.
///
/// Displays a simple message indicating that the numbers game is under
/// construction.  Future phases can implement counting and basic
/// arithmetic activities appropriate for young children.
class NumbersGameScreen extends StatelessWidget {
  const NumbersGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Numere'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(
        child: Text(
          'Jocul Numere este în construcție…',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}