import 'package:flutter/material.dart';

/// Placeholder screen for the Alphabet game.
///
/// Displays a simple message indicating that the alphabet game is under
/// construction.  Future phases can expand this screen into an
/// interactive activity that teaches letters and pronunciation.
class AlphabetGameScreen extends StatelessWidget {
  const AlphabetGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alfabet'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(
        child: Text(
          'Jocul Alfabet este în construcție…',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}