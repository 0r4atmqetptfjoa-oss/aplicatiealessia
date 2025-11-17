import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

/// A simple interactive alphabet game.
///
/// The game shows a random uppercase letter and four options. The player
/// must tap the correct letter. A 3D animated title is displayed at the
/// top using the [ModelViewer] widget. If the GLB file for the title is
/// missing, a fallback text is shown instead. The title auto‑rotates and
/// loops thanks to the model_viewer_plus package, which supports animated
/// glTF/GLB models【210132009004240†L174-L185】.
class AlphabetGameScreen extends StatefulWidget {
  const AlphabetGameScreen({super.key});

  @override
  State<AlphabetGameScreen> createState() => _AlphabetGameScreenState();
}

class _AlphabetGameScreenState extends State<AlphabetGameScreen> {
  final _random = Random();
  late String _currentLetter;
  late List<String> _options;
  int _score = 0;
  int _round = 0;
  static const int _totalRounds = 10;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  /// Generates a new question by selecting a random uppercase letter and
  /// constructing a list of four options (one correct and three incorrect).
  void _generateQuestion() {
    const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    _currentLetter = alphabet[_random.nextInt(alphabet.length)];
    _options = [_currentLetter];
    while (_options.length < 4) {
      final candidate = alphabet[_random.nextInt(alphabet.length)];
      if (!_options.contains(candidate)) {
        _options.add(candidate);
      }
    }
    _options.shuffle(_random);
  }

  void _selectOption(String letter) {
    setState(() {
      if (letter == _currentLetter) {
        _score++;
      }
      _round++;
      if (_round < _totalRounds) {
        _generateQuestion();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alphabet Game'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _round >= _totalRounds ? _buildResult() : _buildQuestion(),
      ),
    );
  }

  /// Builds the question view with an animated 3D title and multiple options.
  Widget _buildQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 3D title using ModelViewer. If the asset is missing, the widget
        // will still render nothing; this is a placeholder to encourage
        // adding a title.glb in assets/models/alphabet/title.glb.
        SizedBox(
          height: 150,
          child: ModelViewer(
            // The GLB file must exist in assets/models/alphabet/title.glb.
            src: 'assets/models/alphabet/title.glb',
            alt: 'Alphabet Title',
            autoPlay: true,
            autoRotate: true,
            disableZoom: true,
            backgroundColor: Colors.transparent,
          ),
        ),
        const SizedBox(height: 16),
        // Animated text fallback overlay using AnimatedTextKit.
        SizedBox(
          height: 40,
          child: DefaultTextStyle(
            // Use the new Material 3 text style. headline5 was renamed to
            // headlineSmall in Flutter 3.19【259856227738898†L509-L519】.
            style: Theme.of(context).textTheme.headlineSmall!,
            child: AnimatedTextKit(
              repeatForever: true,
              animatedTexts: [
                ColorizeAnimatedText(
                  'Select the letter',
                  textStyle: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  colors: [
                    Colors.blue,
                    Colors.red,
                    Colors.green,
                    Colors.purple,
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Which letter is "$_currentLetter"?',
          // headline6 was removed; titleLarge is the new equivalent【259856227738898†L509-L519】.
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        // Options grid
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: _options
              .map(
                (letter) => ElevatedButton(
                  onPressed: () => _selectOption(letter),
                  child: Text(letter,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),
              )
              .toList(),
        ),
        const Spacer(),
        Text('Round ${_round + 1} / $_totalRounds'),
        Text('Score: $_score'),
      ],
    );
  }

  /// Builds the result view displayed after the game ends.
  Widget _buildResult() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Game Complete!',
            // headline4 is deprecated; use headlineMedium【259856227738898†L509-L519】.
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'You scored $_score out of $_totalRounds.',
            // subtitle1 is deprecated; use titleMedium【259856227738898†L509-L519】.
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _score = 0;
                _round = 0;
                _generateQuestion();
              });
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }
}