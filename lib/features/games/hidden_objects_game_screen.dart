import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

/// A simple hidden objects game.
///
/// Displays a grid of icons and prompts the player to find a specific
/// object. The target object is chosen randomly from the grid each round.
/// When the player taps the correct icon, they earn a point and a new
/// round begins. After a set number of rounds the score is displayed.
class HiddenObjectsGameScreen extends StatefulWidget {
  const HiddenObjectsGameScreen({super.key});

  @override
  State<HiddenObjectsGameScreen> createState() => _HiddenObjectsGameScreenState();
}

class _HiddenObjectsGameScreenState extends State<HiddenObjectsGameScreen> {
  final _random = Random();
  late List<IconData> _icons;
  late IconData _target;
  int _score = 0;
  int _round = 0;
  static const int _totalRounds = 5;

  @override
  void initState() {
    super.initState();
    _generateIcons();
    _chooseTarget();
  }

  void _generateIcons() {
    final available = [
      Icons.star,
      Icons.favorite,
      Icons.cake,
      Icons.car_rental,
      Icons.pets,
      Icons.umbrella,
      Icons.sports_soccer,
      Icons.local_florist,
      Icons.coffee,
    ];
    _icons = List<IconData>.from(available)..shuffle(_random);
  }

  void _chooseTarget() {
    _target = _icons[_random.nextInt(_icons.length)];
  }

  void _handleTap(IconData icon) {
    setState(() {
      if (icon == _target) {
        _score++;
      }
      _round++;
      if (_round < _totalRounds) {
        _generateIcons();
        _chooseTarget();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hidden Objects'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _round >= _totalRounds ? _buildResult() : _buildGame(),
      ),
    );
  }

  Widget _buildGame() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 150,
          child: ModelViewer(
            src: 'assets/models/hidden_objects/title.glb',
            alt: 'Hidden Objects Title',
            autoRotate: true,
            autoPlay: true,
            disableZoom: true,
            backgroundColor: Colors.transparent,
          ),
        ),
        const SizedBox(height: 8),
        DefaultTextStyle(
          // headline6 -> titleLarge for Material 3【259856227738898†L509-L519】.
          style: Theme.of(context).textTheme.titleLarge!,
          child: AnimatedTextKit(
            repeatForever: true,
            animatedTexts: [
              TypewriterAnimatedText('Find the target object!'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Find this:',
          // subtitle1 -> titleMedium【259856227738898†L509-L519】.
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Icon(_target, size: 40, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 16),
        // Grid of icons
        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: _icons.map((icon) {
              return InkWell(
                onTap: () => _handleTap(icon),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blueGrey.shade200),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 36,
                      color: Colors.teal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
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
            'Great job!',
            // headline5 -> headlineSmall【259856227738898†L509-L519】.
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(
            'You found $_score of $_totalRounds objects.',
            // subtitle1 -> titleMedium【259856227738898†L509-L519】.
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _score = 0;
                _round = 0;
                _generateIcons();
                _chooseTarget();
              });
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }
}