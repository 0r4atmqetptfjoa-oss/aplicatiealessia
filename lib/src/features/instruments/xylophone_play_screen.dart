import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class XylophonePlayScreen extends StatelessWidget {
  const XylophonePlayScreen({super.key});

  void _playSound(String note) {
    final player = AudioPlayer();
    player.play(AssetSource('audio/instrumente/xilofon/$note.wav'));
  }

  Widget _buildKey({required Color color, required String note}) {
    return Expanded(
      child: InkWell(
        onTap: () => _playSound(note),
        child: Container(color: color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildKey(color: Colors.red, note: 'do'),
          _buildKey(color: Colors.orange, note: 're'),
          _buildKey(color: Colors.yellow, note: 'mi'),
          _buildKey(color: Colors.green, note: 'fa'),
          _buildKey(color: Colors.teal, note: 'sol'),
          _buildKey(color: Colors.blue, note: 'la'),
          _buildKey(color: Colors.purple, note: 'si'),
        ],
      ),
    );
  }
}
