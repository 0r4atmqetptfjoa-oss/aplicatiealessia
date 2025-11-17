import 'dart:math';

import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import '../../services/settings_service.dart';

/// A simple math quiz game.
///
/// This game presents basic arithmetic questions to the user. The player
/// enters an answer into a text field and submits it. The game keeps
/// track of the current question index and the number of correct answers.
/// After a fixed number of questions the final score is displayed along
/// with an option to restart the quiz. This basic implementation
/// demonstrates how you might build out game logic in Flutter.
class MathQuizGameScreen extends StatefulWidget {
  const MathQuizGameScreen({super.key});

  @override
  State<MathQuizGameScreen> createState() => _MathQuizGameScreenState();
}

class _MathQuizGameScreenState extends State<MathQuizGameScreen> {
  final _answerController = TextEditingController();
  final _random = Random();

  // List of generated questions. Each entry is a map containing the
  // question string and its numeric answer. When the game starts
  // the list is populated with random addition and subtraction problems.
  // Use dynamic for values since questions contain both strings and ints.
  late List<Map<String, dynamic>> _questions;

  // Current question index and number of correct answers.
  int _currentQuestion = 0;
  int _score = 0;

  // Whether the quiz has finished.
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _generateQuestions();
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  /// Generate a fixed number of random math questions.
  void _generateQuestions() {
    _questions = [];
    // Determine difficulty from settings. Hard mode adds multiplication and division
    final settings = context.read<SettingsService>();
    final numQuestions = settings.hardMode ? 8 : 5;
    for (int i = 0; i < numQuestions; i++) {
      final a = settings.hardMode ? _random.nextInt(12) + 1 : _random.nextInt(10) + 1;
      final b = settings.hardMode ? _random.nextInt(12) + 1 : _random.nextInt(10) + 1;
      int op;
      if (settings.hardMode) {
        op = _random.nextInt(4); // 0:add,1:sub,2:mul,3:div
      } else {
        op = _random.nextInt(2); // 0:add,1:sub
      }
      String question;
      int answer;
      if (op == 0) {
        question = '$a + $b';
        answer = a + b;
      } else if (op == 1) {
        question = '$a - $b';
        answer = a - b;
      } else if (op == 2) {
        question = '$a × $b';
        answer = a * b;
      } else {
        // For division ensure divisible
        final dividend = a * b;
        question = '$dividend ÷ $a';
        answer = b;
      }
      _questions.add({'question': question, 'answer': answer});
    }
    _currentQuestion = 0;
    _score = 0;
    _isFinished = false;
  }

  /// Handle answer submission.
  void _submitAnswer() {
    final userAnswer = int.tryParse(_answerController.text);
    if (userAnswer != null) {
      final correctAnswer = _questions[_currentQuestion]['answer']!;
      if (userAnswer == correctAnswer) {
        _score++;
      }
      _answerController.clear();
      if (_currentQuestion < _questions.length - 1) {
        setState(() {
          _currentQuestion++;
        });
      } else {
        setState(() {
          _isFinished = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Math Quiz Game'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isFinished ? _buildResult() : _buildQuestionWithTitle(),
      ),
    );
  }

  /// Build the UI for answering a question including a 3D title.
  Widget _buildQuestionWithTitle() {
    final question = _questions[_currentQuestion]['question'] as String;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 150,
          child: ModelViewer(
            src: 'assets/models/math_quiz/title.glb',
            alt: 'Math Quiz Title',
            autoRotate: true,
            autoPlay: true,
            disableZoom: true,
            backgroundColor: Colors.transparent,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Question ${_currentQuestion + 1} of ${_questions.length}',
          // subtitle1 -> titleMedium【259856227738898†L509-L519】.
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Text(
          question,
          // headline4 -> headlineMedium【259856227738898†L509-L519】.
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _answerController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Your answer',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) => _submitAnswer(),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _submitAnswer,
          child: const Text('Submit'),
        ),
      ],
    );
  }

  /// Build the UI showing the quiz results.
  Widget _buildResult() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Quiz Complete!',
          // headline5 -> headlineSmall【259856227738898†L509-L519】.
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Text(
          'You scored $_score out of ${_questions.length}.',
          // subtitle1 -> titleMedium【259856227738898†L509-L519】.
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _generateQuestions();
            });
          },
          child: const Text('Play Again'),
        ),
      ],
    );
  }
}