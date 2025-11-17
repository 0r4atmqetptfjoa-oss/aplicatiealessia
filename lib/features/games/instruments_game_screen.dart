import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

/// A simple instrument identification game.
///
/// On each round the game plays the sound of an instrument (piano, drums or
/// xylophone) and displays three 3D models corresponding to these
/// instruments. The player must tap the correct model to score a point.
/// After a fixed number of rounds a summary is shown. This demonstrates
/// audio playback, random selection and 3D content.
class InstrumentsGameScreen extends StatefulWidget {
  const InstrumentsGameScreen({super.key});

  @override
  State<InstrumentsGameScreen> createState() => _InstrumentsGameScreenState();
}

class _InstrumentsGameState {
  final String name;
  final String modelPath;
  final String soundPath;
  const _InstrumentsGameState(this.name, this.modelPath, this.soundPath);
}

class _InstrumentsGameScreenState extends State<InstrumentsGameScreen> {
  final List<_InstrumentsGameState> _instruments = const [
    _InstrumentsGameState('Piano', 'assets/models/instruments/piano/piano.glb', 'assets/audio/piano_note.wav'),
    _InstrumentsGameState('Drums', 'assets/models/instruments/drums/drums.glb', 'assets/audio/drum_hit.wav'),
    _InstrumentsGameState('Xylophone', 'assets/models/instruments/xylophone/xylophone.glb', 'assets/audio/xylophone_note.wav'),
  ];
  final AudioPlayer _player = AudioPlayer();
  final Random _random = Random();
  late int _targetIndex;
  int _score = 0;
  int _round = 0;
  static const int _totalRounds = 5;
  bool _playingSound = false;

  @override
  void initState() {
    super.initState();
    _startRound();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _startRound() async {
    setState(() {
      _playingSound = true;
      _targetIndex = _random.nextInt(_instruments.length);
    });
    try {
      await _player.play(AssetSource(_instruments[_targetIndex].soundPath));
    } catch (_) {}
    setState(() {
      _playingSound = false;
    });
  }

  void _selectInstrument(int index) {
    if (index == _targetIndex) {
      _score++;
    }
    setState(() {
      _round++;
      if (_round < _totalRounds) {
        _startRound();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instruments Game'),
        centerTitle: true,
      ),
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
        // 3D title
        SizedBox(
          height: 150,
          child: ModelViewer(
            src: 'assets/models/instruments_game/title.glb',
            alt: 'Instruments Game Title',
            autoRotate: true,
            autoPlay: true,
            disableZoom: true,
            backgroundColor: Colors.transparent,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _playingSound ? 'Listening...' : 'Which instrument did you hear?',
          // subtitle1 -> titleMedium【259856227738898†L509-L519】.
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        // Instrument options
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_instruments.length, (index) {
              final inst = _instruments[index];
              return GestureDetector(
                onTap: _playingSound ? null : () => _selectInstrument(index),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: 90,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ModelViewer(
                          src: inst.modelPath,
                          alt: inst.name,
                          autoRotate: true,
                          autoPlay: true,
                          disableZoom: true,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(inst.name),
                  ],
                ),
              );
            }),
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
            'Well done!',
            // headline5 -> headlineSmall【259856227738898†L509-L519】.
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(
            'You guessed $_score out of $_totalRounds instruments.',
            // subtitle1 -> titleMedium【259856227738898†L509-L519】.
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _score = 0;
                _round = 0;
                _startRound();
              });
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }
}