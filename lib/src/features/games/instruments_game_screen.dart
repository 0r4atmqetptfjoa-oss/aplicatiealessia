import 'dart:math';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

/// A simple multiple‑choice game that helps kids recognise musical instruments.
///
/// The game plays a sound for a randomly chosen instrument and shows three
/// picture options. Players must tap the picture corresponding to the sound.
/// The game runs over a fixed number of rounds and displays the final score
/// when all rounds are complete.
class InstrumentsGameScreen extends StatefulWidget {
  const InstrumentsGameScreen({super.key});

  @override
  State<InstrumentsGameScreen> createState() => _InstrumentsGameScreenState();
}

class _InstrumentsGameScreenState extends State<InstrumentsGameScreen> {
  final Random _random = Random();
  final Map<String, String> _instrumentData = {
    'guitar': 'guitar.wav',
    'piano': 'piano.wav',
    'drums': 'drums.wav',
    'violin': 'violin.wav',
    'trumpet': 'trumpet.wav',
    'flute': 'flute.wav',
  };

  late String _targetInstrument;
  late List<String> _options;
  String _message = '';
  int _score = 0;
  int _round = 0;
  final int _totalRounds = 5;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _startGame();
  }

  /// Resets the game state and starts the first round.
  void _startGame() {
    _score = 0;
    _round = 0;
    _generateNewRound();
  }

  /// Sets up a new round by selecting a random target instrument and
  /// constructing a list of three options (including the target).
  void _generateNewRound() {
    if (_round >= _totalRounds) {
      _showGameOverDialog();
      return;
    }
    _round++;
    final keys = _instrumentData.keys.toList();
    _targetInstrument = keys[_random.nextInt(keys.length)];
    _options = List<String>.from(keys)..shuffle();
    _options = _options.take(3).toList();
    if (!_options.contains(_targetInstrument)) {
      _options[_random.nextInt(_options.length)] = _targetInstrument;
    }
    _options.shuffle();
    _playSound();
    setState(() {
      _message = 'What instrument is this?';
    });
  }

  /// Plays the audio file associated with the current target instrument.
  void _playSound() async {
    final file = _instrumentData[_targetInstrument]!;
    await _audioPlayer.play(
      AssetSource('audio/sounds/instruments/$file'),
    );
  }

  /// Handles user selection. Updates score and moves to the next round
  /// after a short delay.
  void _onInstrumentSelected(String instrument) {
    if (instrument == _targetInstrument) {
      setState(() {
        _score++;
        _message = 'Correct!';
      });
    } else {
      setState(() {
        _message = 'Try again!';
      });
    }
    Future.delayed(const Duration(seconds: 1), () {
      _generateNewRound();
    });
  }

  /// Displays a dialog when all rounds have been played, showing the score
  /// and offering options to replay or exit.
  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Great job!'),
          content: Text('Your score: $_score / $_totalRounds'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startGame();
              },
              child: const Text('Play again'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instruments Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Round $_round / $_totalRounds',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
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
            IconButton(
              icon: const Icon(Icons.volume_up, size: 50),
              onPressed: _playSound,
            ),
            const SizedBox(height: 40),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: _options.map((instrument) {
                return GestureDetector(
                  onTap: () => _onInstrumentSelected(instrument),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/games_module/instruments_game/$instrument.png',
                        height: 100,
                        width: 100,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.music_note, size: 100),
                      ),
                      Text(
                        instrument[0].toUpperCase() + instrument.substring(1),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}