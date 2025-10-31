import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

enum Difficulty { easy, medium, hard }

class AlphabetGameScreen extends StatefulWidget {
  const AlphabetGameScreen({super.key});

  @override
  State<AlphabetGameScreen> createState() => _AlphabetGameScreenState();
}

class _AlphabetGameScreenState extends State<AlphabetGameScreen> with TickerProviderStateMixin {
  final Random _random = Random();
  late String _targetLetter;
  late List<String> _options;
  int _score = 0;
  String _message = '';
  Difficulty _difficulty = Difficulty.easy;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AudioPlayer _audioPlayer;

  final Map<String, String> _imageMap = {
    'A': 'apple',
    'B': 'ball',
    'C': 'cat',
    'D': 'dog',
    'E': 'elephant',
    'F': 'fish',
    'G': 'goat',
    'H': 'hat',
    'I': 'ice_cream',
    'J': 'jet',
    'K': 'key',
    'L': 'lion',
  };

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
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
    int numOptions;
    switch (_difficulty) {
      case Difficulty.easy:
        numOptions = 2;
        break;
      case Difficulty.medium:
        numOptions = 3;
        break;
      case Difficulty.hard:
        numOptions = 4;
        break;
    }

    int index = _random.nextInt(_imageMap.length);
    String letter = _imageMap.keys.elementAt(index);
    _targetLetter = letter;

    _options = [letter];
    while (_options.length < numOptions) {
      int randomIndex = _random.nextInt(_imageMap.length);
      String randomLetter = _imageMap.keys.elementAt(randomIndex);
      if (!_options.contains(randomLetter)) {
        _options.add(randomLetter);
      }
    }
    _options.shuffle();

    setState(() {
      _message = '';
    });
  }

  void _onLetterDropped(String letter) {
    if (letter == _targetLetter) {
      setState(() {
        _score++;
        _message = 'Correct!';
      });
      _audioPlayer.play(AssetSource('audio/correct.mp3'));
      _animationController.forward().then((_) {
        _animationController.reverse();
        Future.delayed(const Duration(seconds: 1), () {
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
    String targetImage = _imageMap[_targetLetter] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alphabet Game'),
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
              'Drag the correct letter to the image',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ScaleTransition(
              scale: _animation,
              child: DragTarget<String>(
                builder: (context, candidateData, rejectedData) {
                  return Image.asset(
                    'assets/images/games_module/alphabet_game/$targetImage.png',
                    height: 150,
                    width: 150,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 150),
                  );
                },
                onAccept: _onLetterDropped,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _options.map((letter) {
                return Draggable<String>(
                  data: letter,
                  feedback: _buildDraggableLetter(letter, 60),
                  childWhenDragging: _buildDraggableLetter(letter, 50, color: Colors.grey.withOpacity(0.5)),
                  child: _buildDraggableLetter(letter, 50),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text(
              _message,
              style: const TextStyle(fontSize: 24, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDraggableLetter(String letter, double size, {Color? color}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color ?? Colors.blue.shade100,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(fontSize: size * 0.6, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
