import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

enum Difficulty { easy, medium, hard }

class NumbersGameScreen extends StatefulWidget {
  const NumbersGameScreen({super.key});

  @override
  State<NumbersGameScreen> createState() => _NumbersGameScreenState();
}

class _NumbersGameScreenState extends State<NumbersGameScreen> with TickerProviderStateMixin {
  final Random _random = Random();
  late int _correctAnswer;
  late List<int> _options;
  String _message = '';
  int _score = 0;
  Difficulty _difficulty = Difficulty.easy;
  late IconData _displayIcon;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AudioPlayer _audioPlayer;

  final List<IconData> _icons = [
    Icons.star,
    Icons.favorite,
    Icons.anchor,
    Icons.bug_report,
    Icons.camera,
    Icons.directions_bike,
    Icons.emoji_food_beverage,
    Icons.flutter_dash,
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _generateNewRound();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _generateNewRound() {
    int maxNumber;
    int numOptions;
    switch (_difficulty) {
      case Difficulty.easy:
        maxNumber = 5;
        numOptions = 3;
        break;
      case Difficulty.medium:
        maxNumber = 10;
        numOptions = 4;
        break;
      case Difficulty.hard:
        maxNumber = 15;
        numOptions = 5;
        break;
    }
    _correctAnswer = _random.nextInt(maxNumber) + 1;
    _displayIcon = _icons[_random.nextInt(_icons.length)];

    _options = [_correctAnswer];
    while (_options.length < numOptions) {
      int wrongAnswer = _random.nextInt(maxNumber) + 1;
      if (!_options.contains(wrongAnswer)) {
        _options.add(wrongAnswer);
      }
    }
    _options.shuffle();

    setState(() {
      _message = 'How many items are there?';
    });
    _animationController.reset();
    _animationController.forward();
  }

  void _onNumberSelected(int number) {
    if (number == _correctAnswer) {
      setState(() {
        _score++;
        _message = 'Correct!';
      });
      _audioPlayer.play(AssetSource('audio/correct.mp3'));
      Future.delayed(const Duration(seconds: 1), () {
        _generateNewRound();
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
        title: const Text('Numbers Game'),
        actions: [
          PopupMenuButton<Difficulty>(
            onSelected: (Difficulty result) {
              setState(() {
                _difficulty = result;
                _score = 0;
                _generateNewRound();
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Difficulty>>[
              const PopupMenuItem<Difficulty>(
                value: Difficulty.easy,
                child: Text('Easy'),
              ),
              const PopupMenuItem<Difficulty>(
                value: Difficulty.medium,
                child: Text('Medium'),
              ),
              const PopupMenuItem<Difficulty>(
                value: Difficulty.hard,
                child: Text('Hard'),
              ),
            ],
          ),
        ],
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
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _animation,
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: List.generate(_correctAnswer, (index) {
                  return Icon(_displayIcon, size: 40, color: Colors.blue);
                }),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _options.map((number) {
                return ElevatedButton(
                  onPressed: () => _onNumberSelected(number),
                  child: Text('$number', style: const TextStyle(fontSize: 24)),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text(
              _message == 'Correct!' ? _message : ( _message == 'Try again!' ? _message : '' ),
              style: TextStyle(fontSize: 24, color: _message == 'Correct!' ? Colors.green : Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
