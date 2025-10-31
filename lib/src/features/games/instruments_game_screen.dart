import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class InstrumentsGameScreen extends StatefulWidget {
  const InstrumentsGameScreen({super.key});

  @override
  State<InstrumentsGameScreen> createState() => _InstrumentsGameScreenState();
}

class _InstrumentsGameScreenState extends State<InstrumentsGameScreen> {
  final Random _random = Random();
  late String _targetInstrument;
  late List<String> _options;
  String _message = '';
  int _score = 0;
  late AudioPlayer _audioPlayer;

  final Map<String, String> _instrumentData = {
    'guitar': 'guitar.mp3',
    'piano': 'piano.mp3',
    'drums': 'drums.mp3',
    'violin': 'violin.mp3',
  };

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _generateNewRound();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _generateNewRound() {
    int index = _random.nextInt(_instrumentData.length);
    _targetInstrument = _instrumentData.keys.elementAt(index);
    _options = _instrumentData.keys.toList()..shuffle();
    _options = _options.take(3).toList();
    if (!_options.contains(_targetInstrument)) {
      _options[_random.nextInt(3)] = _targetInstrument;
    }
    _options.shuffle();
    _playSound();

    setState(() {
      _message = 'What instrument is this?';
    });
  }

  void _playSound() {
    String soundFile = _instrumentData[_targetInstrument]!;
    _audioPlayer.play(AssetSource('audio/sounds/instruments/$soundFile'));
  }

  void _onInstrumentSelected(String instrument) {
    if (instrument == _targetInstrument) {
      setState(() {
        _score++;
        _message = 'Correct!';
      });
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
        title: const Text('Instruments Game'),
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
            IconButton(
              icon: const Icon(Icons.volume_up, size: 50),
              onPressed: _playSound,
            ),
            const SizedBox(height: 40),
            Wrap(
              spacing: 10,
              runSpacing: 10,
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
                      Text(instrument, style: const TextStyle(fontSize: 16)),
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
