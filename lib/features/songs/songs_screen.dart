import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/audio_service.dart';
import 'package:alesia/services/song_playlist_service.dart';
import 'package:alesia/services/ab_test_service.dart';
import 'package:alesia/widgets/spectrum_visualizer.dart';
import 'package:alesia/services/audio_analyzer_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/foundation.dart';

class SongsScreen extends StatefulWidget {
  const SongsScreen({super.key});
  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  final analyzer = AudioAnalyzerService();
  final playlist = SongPlaylistService();
  int current = 0;
  bool playing = false;
  bool loopAB = false;
  int? loopStartIndex;
  int? loopEndIndex;

  @override
  void initState() {
    super.initState();
    playlist.loadFromAssets();
  }

  @override
  Widget build(BuildContext context) {
    final audio = getIt<AudioService>();
    final ab = getIt<ABTestService>();
    final variant = ab.getVariant('visualizer_style'); // 'A' bare, 'B' cercuri
    return Scaffold(
      appBar: AppBar(title: const Text('Cântece - Player Avansat')),
      body: FutureBuilder(
        future: playlist.loadFromAssets(),
        builder: (context, snap) {
          if (playlist.tracks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          final track = playlist.tracks[current];
          return Column(
            children: [
              const SizedBox(height: 12),
              // Vizualizator "reactiv" (bazat pe BPM & poziție)
              ValueListenableBuilder<double>(
                  valueListenable: audio.musicPosSec,
                  builder: (context, pos, _) {
                    return SpectrumVisualizer(positionSec: audio.musicPosSec, bars: 18, bpm: track.bpm, variant: variant).animate().fadeIn();
                  }),
              const SizedBox(height: 8),
              Text(track.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              // Timeline + slider
              ValueListenableBuilder<double>(
                valueListenable: audio.musicPosSec,
                builder: (context, pos, _) {
                  final dur = audio.musicDurSec.value;
                  return Column(
                    children: [
                      Slider(
                        value: pos.clamp(0, dur > 0 ? dur : 1),
                        min: 0, max: dur > 0 ? dur : 1,
                        onChanged: (v) => audio.seek(v),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_fmt(pos)),
                            Text(_fmt(dur)),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 6),
              // Marcaje
              Wrap(
                spacing: 8, runSpacing: 8, alignment: WrapAlignment.center,
                children: List.generate(track.markers.length, (i) {
                  final m = track.markers[i];
                  final selected = (loopStartIndex == i) || (loopEndIndex == i);
                  return ChoiceChip(
                    label: Text(m.label),
                    selected: selected,
                    onSelected: (_) {
                      getIt<AudioService>().seek(m.timeSec);
                      setState(() {
                        if (loopStartIndex == null) {
                          loopStartIndex = i;
                        } else if (loopEndIndex == null) {
                          loopEndIndex = i;
                          loopAB = true;
                        } else {
                          loopStartIndex = i;
                          loopEndIndex = null;
                          loopAB = false;
                        }
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async => prev(),
                    icon: const Icon(Icons.skip_previous), label: const Text('Precedent'),
                  ).animate().scale(),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () async => toggle(),
                    icon: Icon(playing ? Icons.pause : Icons.play_arrow), label: Text(playing ? 'Pauză' : 'Redă'),
                  ).animate().scale(),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () async => next(),
                    icon: const Icon(Icons.skip_next), label: const Text('Următor'),
                  ).animate().scale(),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilterChip(
                    label: const Text('Loop A-B'),
                    selected: loopAB,
                    onSelected: (on) => setState(() => loopAB = on),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () => setState(() { loopStartIndex = null; loopEndIndex = null; loopAB = false; }),
                    child: const Text('Reset loop'),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: playlist.tracks.length,
                  itemBuilder: (context, i) {
                    final t = playlist.tracks[i];
                    return ListTile(
                      leading: Icon(i == current ? Icons.music_note : Icons.queue_music),
                      title: Text(t.title),
                      subtitle: Text('${t.durationSec.round()}s • ${t.bpm} BPM'),
                      onTap: () => playIndex(i),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _fmt(double sec) {
    final s = sec.floor();
    final m = (s ~/ 60).toString().padLeft(2,'0');
    final ss = (s % 60).toString().padLeft(2,'0');
    return '$m:$ss';
  }

  Future<void> playIndex(int i) async {
    current = i;
    setState(() {});
    final track = playlist.tracks[current];
    getIt<AudioService>().setMusicDuration(track.durationSec);
    await getIt<AudioService>().playNote(track.id);
    playing = true;
    setState(() {});
  }

  Future<void> toggle() async {
    final audio = getIt<AudioService>();
    if (!playing) {
      await playIndex(current);
    } else {
      await audio.stopAmbient();
      playing = false;
      setState(() {});
    }
  }

  Future<void> next() async {
    final i = (current + 1) % playlist.tracks.length;
    await playIndex(i);
  }

  Future<void> prev() async {
    final i = (current - 1 + playlist.tracks.length) % playlist.tracks.length;
    await playIndex(i);
  }
}