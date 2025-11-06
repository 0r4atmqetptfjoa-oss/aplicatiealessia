import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class DrumsPlayScreen extends StatelessWidget {
  const DrumsPlayScreen({super.key});

  void _playSound(String sound) {
    final player = AudioPlayer();
    player.play(AssetSource('audio/instrumente/tobe/$sound.wav'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepOrange, Colors.brown],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDrum('crash', 100, Colors.amber),
                  _buildDrum('hihat', 120, Colors.grey),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDrum('snare', 150, Colors.blueGrey),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDrum('kick', 200, Colors.red.shade900),
                  _buildDrum('tom', 180, Colors.indigo),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrum(String sound, double size, Color color) {
    return InkWell(
      onTap: () => _playSound(sound),
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 4),
          boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(5, 5))],
        ),
      ),
    );
  }
}
