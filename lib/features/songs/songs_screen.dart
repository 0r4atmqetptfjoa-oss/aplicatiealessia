import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/ab_test_service.dart';
import 'package:alesia/services/audio_service.dart';
import 'package:alesia/widgets/song_timeline.dart';
import 'package:alesia/widgets/spectrum_visualizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rive/rive.dart';

class SongsScreen extends StatefulWidget {
  const SongsScreen({super.key});

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  // TODO (Răzvan): înlocuiește IDs cu piese reale în assets/audio/final/
  final tracks = const [
    {'id': 'bg_music', 'title': 'Tema Alesia', 'markers': [ {'t': 0.0, 'label': 'Intro'}, {'t': 30.0, 'label': 'Strofa'}, {'t': 60.0, 'label': 'Refren'} ]},
    {'id': 'song_1',   'title': 'Valsul Stelelor', 'markers': [ {'t': 0.0, 'label': 'Intro'}, {'t': 28.0, 'label': 'Tema'} ]},
    {'id': 'song_2',   'title': 'Dansul Pădurii',  'markers': [ {'t': 0.0, 'label': 'Intro'}, {'t': 20.0, 'label': 'Pulse'} ]},
  ];

  int current = 0;
  late final String variant; // A/B layout

  @override
  void initState() {
    super.initState();
    final ab = getIt<ABTestService>();
    variant = ab.assign('SongsControlsLayout', const ['classic', 'compact']);
  }

  AudioService get audio => getIt<AudioService>();

  @override
  Widget build(BuildContext context) {
    final id = tracks[current]['id']!;
    final title = tracks[current]['title']!;
    final duration = audio.currentDuration(id);
    final markers = (tracks[current]['markers'] as List).map((e) => SongMarker((e['t'] as num).toDouble(), e['label'] as String)).toList();

    final controls = _Controls(
      playingListenable: audio.musicPlaying,
      onPlay: () async => _playIndex(current),
      onPause: () async => audio.stopMusic(),
      onPrev: () => _prev(),
      onNext: () => _next(),
    );

    final timeline = ValueListenableBuilder<double>(
      valueListenable: audio.musicProgress,
      builder: (context, p, _) => SongTimeline(
        progress: p,
        duration: duration,
        markers: markers,
        seekingEnabled: audio.supportsSeeking,
        onSeekTo: (v) => audio.seekToFraction(v),
        onJumpTo: (sec) {
          final frac = (sec / duration.inSeconds).clamp(0.0, 1.0);
          audio.seekToFraction(frac);
        },
      ),
    );

    final visualizer = ValueListenableBuilder<double>(
      valueListenable: audio.musicProgress,
      builder: (context, p, _) => SizedBox(
        height: 120,
        child: SpectrumVisualizer(progress: audio.musicProgress),
      ),
    );

    final rive = const SizedBox(
      height: 160,
      child: RiveAnimation.asset(
        // TODO (Răzvan): Înlocuiește cu 'assets/rive/conductor.riv' când e disponibil
        'assets/rive/zana_melodia.riv',
        animations: ['idle'],
        fit: BoxFit.contain,
      ),
    );

    Widget body;
    if (variant == 'classic') {
      body = Column(
        children: [
          const SizedBox(height: 8),
          rive,
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))).animate().fadeIn(),
          controls,
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: timeline),
          const SizedBox(height: 8),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: visualizer),
          const SizedBox(height: 8),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: const FftWaterfall()),
          const SizedBox(height: 8),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: const FftWaterfall()),
          const Divider(),
          Expanded(child: _TrackList(tracks: tracks, current: current, onTap: (i) => _playIndex(i))),
        ],
      );
    } else {
      // compact
      body = Column(
        children: [
          const SizedBox(height: 8),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: timeline),
          const SizedBox(height: 8),
          rive,
          const SizedBox(height: 8),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: visualizer),
          const SizedBox(height: 8),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: const FftWaterfall()),
          const SizedBox(height: 8),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: const FftWaterfall()),
          const SizedBox(height: 8),
          controls,
          const Divider(),
          Expanded(child: _TrackList(tracks: tracks, current: current, onTap: (i) => _playIndex(i))),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Cântece (avansat)')),
      body: body,
    );
  }

  Future<void> _playIndex(int i) async {
    setState(() => current = i);
    await audio.playMusic(tracks[i]['id']!);
  }

  Future<void> _next() async {
    final i = (current + 1) % tracks.length;
    await _playIndex(i);
  }

  Future<void> _prev() async {
    final i = (current - 1 + tracks.length) % tracks.length;
    await _playIndex(i);
  }
}

class _Controls extends StatelessWidget {
  final ValueListenable<bool> playingListenable;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _Controls({required this.playingListenable, required this.onPlay, required this.onPause, required this.onPrev, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: playingListenable,
      builder: (context, playing, _) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(icon: const Icon(Icons.skip_previous), onPressed: onPrev),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: playing ? onPause : onPlay,
            icon: Icon(playing ? Icons.pause : Icons.play_arrow),
            label: Text(playing ? 'Pauză' : 'Redă'),
          ),
          const SizedBox(width: 8),
          IconButton(icon: const Icon(Icons.skip_next), onPressed: onNext),
        ],
      ),
    );
  }
}

class _TrackList extends StatelessWidget {
  final List<Map<String, dynamic>> tracks;
  final int current;
  final ValueChanged<int> onTap;
  const _TrackList({required this.tracks, required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tracks.length,
      itemBuilder: (context, i) => ListTile(
        leading: Icon(i == current ? Icons.music_note : Icons.queue_music),
        title: Text(tracks[i]['title']!),
        onTap: () => onTap(i),
      ),
    );
  }
}
