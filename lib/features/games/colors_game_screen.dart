import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

/// A simple colour matching game.
///
/// The player is shown the name of a colour and must select the corresponding
/// coloured button. The game tracks the score over a fixed number of rounds.
/// A 3D animated title is displayed at the top; if the GLB file is missing
/// a fallback animated text is shown.
class ColorsGameScreen extends StatefulWidget {
  const ColorsGameScreen({super.key});

  @override
  State<ColorsGameScreen> createState() => _ColorsGameScreenState();
}

class _ColorsGameState {
  final String name;
  final Color color;
  const _ColorsGameState(this.name, this.color);
}

class _ColorsGameScreenState extends State<ColorsGameScreen> {
  final _random = Random();
  static const List<_ColorsGameState> _colours = [
    _ColorsGameState('Red', Colors.red),
    _ColorsGameState('Blue', Colors.blue),
    _ColorsGameState('Green', Colors.green),
    _ColorsGameState('Yellow', Colors.yellow),
    _ColorsGameState('Orange', Colors.orange),
  ];
  late _ColorsGameState _current;
  late List<_ColorsGameState> _options;
  int _score = 0;
  int _round = 0;
  static const int _totalRounds = 8;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    _current = _colours[_random.nextInt(_colours.length)];
    _options = [_current];
    while (_options.length < 4) {
      final candidate = _colours[_random.nextInt(_colours.length)];
      if (!_options.contains(candidate)) {
        _options.add(candidate);
      }
    }
    _options.shuffle(_random);
  }

  void _selectOption(_ColorsGameState chosen) {
    setState(() {
      if (chosen == _current) {
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
        title: const Text('Colours Game'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _round >= _totalRounds ? _buildResult() : _buildQuestion(),
      ),
    );
  }

  Widget _buildQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 150,
          child: ModelViewer(
            src: 'assets/models/colors/title.glb',
            alt: 'Colours Title',
            autoPlay: true,
            autoRotate: true,
            disableZoom: true,
            backgroundColor: Colors.transparent,
          ),
        ),
        SizedBox(
          height: 40,
          child: DefaultTextStyle(
            // Use headlineSmall instead of headline5【259856227738898†L509-L519】.
            style: Theme.of(context).textTheme.headlineSmall!,
            child: AnimatedTextKit(
              repeatForever: true,
              animatedTexts: [
                WavyAnimatedText('Match the colour'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _current.name,
          // headline4 -> headlineMedium【259856227738898†L509-L519】.
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: _current.color,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: _options
              .map(
                (opt) => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: opt.color,
                    minimumSize: const Size(80, 50),
                  ),
                  onPressed: () => _selectOption(opt),
                  child: Container(),
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

  Widget _buildResult() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Finished!',
            // headline4 replaced by headlineMedium【259856227738898†L509-L519】.
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'You scored $_score out of $_totalRounds.',
            // subtitle1 replaced by titleMedium【259856227738898†L509-L519】.
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