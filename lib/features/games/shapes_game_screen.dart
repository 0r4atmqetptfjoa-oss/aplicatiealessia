import 'dart:math';

import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

/// A shape recognition game using 3D models.
///
/// Each round displays a 3D model of a geometric shape (cube, sphere, or
/// cylinder) and asks the player to select the correct name from three
/// options. A score is kept over several rounds. This demonstrates
/// integration of 3D content with interactive quiz mechanics.
class ShapesGameScreen extends StatefulWidget {
  const ShapesGameScreen({super.key});

  @override
  State<ShapesGameScreen> createState() => _ShapesGameScreenState();
}

class _ShapeInfo {
  final String name;
  final String modelPath;
  const _ShapeInfo(this.name, this.modelPath);
}

class _ShapesGameScreenState extends State<ShapesGameScreen> {
  final List<_ShapeInfo> _shapes = const [
    _ShapeInfo('Cube', 'assets/models/shapes/cube.glb'),
    _ShapeInfo('Sphere', 'assets/models/shapes/sphere.glb'),
    _ShapeInfo('Cylinder', 'assets/models/shapes/cylinder.glb'),
  ];
  final Random _random = Random();
  late _ShapeInfo _current;
  late List<String> _options;
  int _score = 0;
  int _round = 0;
  static const int _totalRounds = 6;

  @override
  void initState() {
    super.initState();
    _generateRound();
  }

  void _generateRound() {
    _current = _shapes[_random.nextInt(_shapes.length)];
    _options = [_current.name];
    while (_options.length < 3) {
      final candidate = _shapes[_random.nextInt(_shapes.length)].name;
      if (!_options.contains(candidate)) _options.add(candidate);
    }
    _options.shuffle(_random);
  }

  void _selectOption(String name) {
    setState(() {
      if (name == _current.name) {
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
      appBar: AppBar(title: const Text('Shapes Game'), centerTitle: true),
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
            src: 'assets/models/shapes/title.glb',
            alt: 'Shapes Title',
            autoRotate: true,
            autoPlay: true,
            disableZoom: true,
            backgroundColor: Colors.transparent,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'What shape is this?',
          // subtitle1 -> titleMedium【259856227738898†L509-L519】.
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        // Display 3D shape model
        Expanded(
          child: ModelViewer(
            src: _current.modelPath,
            alt: _current.name,
            autoRotate: true,
            autoPlay: true,
            disableZoom: true,
            backgroundColor: Colors.transparent,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: _options
              .map((name) => ElevatedButton(
                    onPressed: () => _selectOption(name),
                    child: Text(name),
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
          Text('You finished the shapes game!',
              // headline5 -> headlineSmall【259856227738898†L509-L519】.
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          Text('Score: $_score / $_totalRounds',
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