import 'dart:math';
import 'package:flutter/material.dart';

enum Difficulty { easy, medium, hard }

class MathQuizGameScreen extends StatefulWidget {
  const MathQuizGameScreen({super.key});

  @override
  State<MathQuizGameScreen> createState() => _MathQuizGameScreenState();
}

class _MathQuizGameScreenState extends State<MathQuizGameScreen> with TickerProviderStateMixin {
  final Random _random = Random();
  late int _num1, _num2, _correctAnswer;
  late String _operator;
  late List<int> _options;
  String _message = '';
  int _score = 0;
  Difficulty _difficulty = Difficulty.easy;
  int? _selectedAnswer;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticIn),
    );
    _generateNewQuestion();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _generateNewQuestion() {
    int maxNumber;
    List<String> operators;
    switch (_difficulty) {
      case Difficulty.easy:
        maxNumber = 10;
        operators = ['+', '-'];
        break;
      case Difficulty.medium:
        maxNumber = 20;
        operators = ['+', '-', '*'];
        break;
      case Difficulty.hard:
        maxNumber = 50;
        operators = ['+', '-', '*', '/'];
        break;
    }

    _operator = operators[_random.nextInt(operators.length)];
    _num1 = _random.nextInt(maxNumber) + 1;
    _num2 = _random.nextInt(maxNumber) + 1;

    if (_operator == '-' && _num1 < _num2) {
      int temp = _num1;
      _num1 = _num2;
      _num2 = temp;
    }

    if (_operator == '/') {
      if (_num2 == 0) _num2 = 1;
      _num1 = (_random.nextInt(maxNumber ~/ _num2) + 1) * _num2;
    }

    switch (_operator) {
      case '+':
        _correctAnswer = _num1 + _num2;
        break;
      case '-':
        _correctAnswer = _num1 - _num2;
        break;
      case '*':
        _correctAnswer = _num1 * _num2;
        break;
      case '/':
        _correctAnswer = _num1 ~/ _num2;
        break;
    }

    _options = [_correctAnswer];
    while (_options.length < 4) {
      int wrongAnswer = _random.nextInt(_correctAnswer + 20) + 1;
      if (!_options.contains(wrongAnswer)) {
        _options.add(wrongAnswer);
      }
    }
    _options.shuffle();

    setState(() {
      _message = '';
      _selectedAnswer = null;
    });
  }

  void _onAnswerSelected(int answer) {
    setState(() {
      _selectedAnswer = answer;
    });
    if (answer == _correctAnswer) {
      setState(() {
        _score++;
        _message = 'Correct!';
      });
      _animationController.forward().then((_) {
        _animationController.reverse();
        Future.delayed(const Duration(seconds: 1), () {
          _generateNewQuestion();
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
        title: const Text('Math Quiz'),
        actions: [
          PopupMenuButton<Difficulty>(
            onSelected: (Difficulty result) {
              setState(() {
                _difficulty = result;
                _score = 0; // Reset score on difficulty change
                _generateNewQuestion();
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
            ScaleTransition(
              scale: _animation,
              child: Text(
                '$_num1 $_operator $_num2 = ?',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _options.map((option) {
                bool isSelected = _selectedAnswer == option;
                Color buttonColor;
                if (isSelected) {
                  buttonColor = option == _correctAnswer ? Colors.green : Colors.red;
                } else {
                  buttonColor = Colors.blue;
                }
                return ElevatedButton(
                  onPressed: () => _onAnswerSelected(option),
                  style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
                  child: Text('$option', style: const TextStyle(fontSize: 24)),
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
}
