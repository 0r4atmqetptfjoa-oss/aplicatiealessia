import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../services/tts_service.dart';

/// A simple alphabet learning game.
///
/// Displays a grid of colourful letter blocks.  When a child taps
/// a block, the corresponding letter is spoken aloud using the
/// [TtsService].  A subtle scale animation provides tactile feedback.
class AlphabetScreen extends StatefulWidget {
  const AlphabetScreen({super.key});

  @override
  State<AlphabetScreen> createState() => _AlphabetScreenState();
}

class _AlphabetScreenState extends State<AlphabetScreen>
    with SingleTickerProviderStateMixin {
  final TtsService _ttsService = TtsService();
  final List<String> _letters = ['A', 'B', 'C', 'D'];
  final Map<String, String> _assetMap = {
    'A': 'assets/images/games/alphabet/letter_a.png',
    'B': 'assets/images/games/alphabet/letter_b.png',
    'C': 'assets/images/games/alphabet/letter_c.png',
    'D': 'assets/images/games/alphabet/letter_d.png',
  };
  final Map<String, bool> _tapping = {};

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    for (final letter in _letters) {
      _tapping[letter] = false;
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  Future<void> _onTap(String letter) async {
    setState(() => _tapping[letter] = true);
    await _ttsService.speak(letter);
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() => _tapping[letter] = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alfabet'),
        leading: BackButton(onPressed: () => Navigator.of(context).pop()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: _letters.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final letter = _letters[index];
            final asset = _assetMap[letter]!;
            final bool tapping = _tapping[letter] ?? false;
            return GestureDetector(
              onTap: () => _onTap(letter),
              child: AnimatedScale(
                duration: const Duration(milliseconds: 150),
                scale: tapping ? 0.85 : 1.0,
                curve: Curves.easeOut,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(asset),
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