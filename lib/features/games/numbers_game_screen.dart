import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import '../../services/settings_service.dart';

/// A simple numbers counting game.
///
/// The player sees a collection of icons representing a random number of
/// objects (1–5) and must choose the correct digit from several options.
/// After a fixed number of rounds the score is displayed.
class NumbersGameScreen extends StatefulWidget {
  const NumbersGameScreen({super.key});

  @override
  State<NumbersGameScreen> createState() => _NumbersGameScreenState();
}

class _NumbersGameScreenState extends State<NumbersGameScreen> {
  final _random = Random();
  late int _currentNumber;
  late List<int> _options;
  int _score = 0;
  int _round = 0;
  static const int _totalRounds = 6;

  @override
  void initState() {
    super.initState();
    _generateRound();
  }

  void _generateRound() {
    final hardMode = context.read<SettingsService>().hardMode;
    final maxNumber = hardMode ? 10 : 5;
    _currentNumber = _random.nextInt(maxNumber) + 1;
    _options = [_currentNumber];
    // generate 3 more unique numbers
    while (_options.length < 4) {
      final candidate = _random.nextInt(maxNumber) + 1;
      if (!_options.contains(candidate)) {
        _options.add(candidate);
      }
    }
    _options.shuffle(_random);
  }

  void _selectOption(int value) {
    setState(() {
      if (value == _currentNumber) {
        _score++;
      }
      _round++;
      if (_round < _totalRounds) {
        _generateRound();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Numbers Game'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _round >= _totalRounds ? _buildResult() : _buildRound(),
      ),
    );
  }

  Widget _buildRound() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 150,
          child: ModelViewer(
            src: 'assets/models/numbers/title.glb',
            alt: 'Numbers Game Title',
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
              ScaleAnimatedText('Count the items!'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Display icons repeated _currentNumber times
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(_currentNumber, (index) {
            return const Icon(Icons.star, size: 40, color: Colors.amber);
          }),
        ),
        const SizedBox(height: 24),
        // Options for numbers 1-5
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: _options
              .map((value) => ElevatedButton(
                    onPressed: () => _selectOption(value),
                    child: Text(
                      value.toString(),
                      style: const TextStyle(fontSize: 24),
                    ),
                  ))
              .toList(),
        ),
        const Spacer(),
        Text('Round ${_round + 1} / $_totalRounds'),
        Text('Score: $_score'),
      ],
    );
  }

  Widget _buildResult() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Great counting!',
              // headline5 -> headlineSmall【259856227738898†L509-L519】.
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          Text('You got $_score out of $_totalRounds correct.',
              // subtitle1 -> titleMedium【259856227738898†L509-L519】.
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _score = 0;
                _round = 0;
                _generateRound();
              });
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }
}