import 'dart:math';
import 'package:flutter/material.dart';

class ColorsGameScreen extends StatefulWidget {
  const ColorsGameScreen({super.key});

  @override
  State<ColorsGameScreen> createState() => _ColorsGameScreenState();
}

class _ColorsGameScreenState extends State<ColorsGameScreen> with TickerProviderStateMixin {
  final Random _random = Random();
  late Color _targetColor;
  late List<Color> _options;
  String _message = '';
  int _score = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final Map<String, Color> _colorMap = {
    'Red': Colors.red,
    'Green': Colors.green,
    'Blue': Colors.blue,
    'Yellow': Colors.yellow,
    'Orange': Colors.orange,
    'Purple': Colors.purple,
    'Pink': Colors.pink,
    'Brown': Colors.brown,
    'Black': Colors.black,
    'White': Colors.white,
    'Cyan': Colors.cyan,
    'Magenta': Colors.magenta,
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _generateNewRound();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _generateNewRound() {
    _targetColor = _colorMap.values.toList()[_random.nextInt(_colorMap.length)];
    _options = _colorMap.values.toList()..shuffle();
    _options = _options.take(4).toList();
    if (!_options.contains(_targetColor)) {
      _options[_random.nextInt(4)] = _targetColor;
    }
    _message = 'Select the color ${_getDisplayName(_targetColor)}';
    setState(() {});
  }

  String _getDisplayName(Color color) {
    for (var entry in _colorMap.entries) {
      if (entry.value == color) {
        return entry.key;
      }
    }
    return '';
  }

  void _onColorSelected(Color color) {
    if (color == _targetColor) {
      setState(() {
        _score++;
        _message = 'Correct!';
      });
      _animationController.forward().then((_) {
        _animationController.reverse();
        Future.delayed(const Duration(milliseconds: 500), () {
          _generateNewRound();
        });
      });
    } else {
      setState(() {
        _message = 'Try again!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Colors Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Score: $_score',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              _message,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ScaleTransition(
              scale: _animation,
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _options.map((color) {
                  return GestureDetector(
                    onTap: () => _onColorSelected(color),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: color,
                        border: color == Colors.white ? Border.all(color: Colors.black) : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
