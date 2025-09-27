import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SongsScreen extends StatefulWidget {
  const SongsScreen({super.key});

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  final tracks = const [
    {'id': 'bg_music', 'title': 'Tema Alesia'},
    {'id': 'song_1', 'title': 'Valsul Stelelor'},
    {'id': 'song_2', 'title': 'Dansul Pădurii'},
  ];
  int current = 0;
  bool playing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cântece - Playlist')),
      body: Column(
        children: [
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: prev, icon: const Icon(Icons.skip_previous), iconSize: 36).animate().scale(),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: toggle,
                  icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                  label: Text(playing ? 'Pauză' : 'Redă'),
                ).animate().scale(),
                const SizedBox(width: 8),
                IconButton(onPressed: next, icon: const Icon(Icons.skip_next), iconSize: 36).animate().scale(),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: const [
                  // TODO (Răzvan): Înlocuiește cu 'conductor.riv' când e disponibil
                  RiveAnimation.asset('assets/rive/zana_melodia.riv', animations: ['idle']),
                ],
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: tracks.length,
              itemBuilder: (context, i) => ListTile(
                leading: Icon(i == current ? Icons.music_note : Icons.queue_music),
                title: Text(tracks[i]['title']!),
                onTap: () => playIndex(i),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> playIndex(int i) async {
    current = i;
    setState(() {});
    await getIt<AudioService>().playMusic(tracks[current]['id']!);
    playing = true;
    setState(() {});
  }

  Future<void> toggle() async {
    if (!playing) {
      await playIndex(current);
    } else {
      await getIt<AudioService>().stopMusic();
      playing = false;
      setState(() {});
    }
  }

  Future<void> next() async {
    final i = (current + 1) % tracks.length;
    await playIndex(i);
  }

  Future<void> prev() async {
    final i = (current - 1 + tracks.length) % tracks.length;
    await playIndex(i);
  }
}
