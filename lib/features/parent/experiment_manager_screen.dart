import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/ab_test_service.dart';
import 'package:alesia/services/analytics_service.dart';
import 'package:flutter/material.dart';

class ExperimentManagerScreen extends StatelessWidget {
  const ExperimentManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ab = getIt<ABTestService>();
    final an = getIt<AnalyticsService>();
    final assignments = ab.getAll();

    // rapoarte locale simple
    final songs = <String,int>{};
    final coach = <String,int>{};

    for (final e in an.events) {
      if (e.type == 'song_play') {
        final v = (e.data['songsLayoutVar'] ?? 'classic').toString();
        songs[v] = (songs[v] ?? 0) + 1;
      }
      if (e.type == 'coach_success') {
        final v = (e.data['coachHintsVar'] ?? 'sticky').toString();
        coach[v] = (coach[v] ?? 0) + 1;
      }
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Experiment Manager', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        const Text('Asignări curente:'),
        Wrap(spacing: 8, children: assignments.entries.map((e) => Chip(label: Text('${e.key}: ${e.value}'))).toList()),
        const Divider(height: 32),
        const Text('Raport local — SongsControlsLayout (event: song_play)'),
        Wrap(spacing: 8, children: songs.entries.map((e) => Chip(label: Text('${e.key}: ${e.value}'))).toList()),
        const SizedBox(height: 12),
        const Text('Raport local — CoachHints (event: coach_success)'),
        Wrap(spacing: 8, children: coach.entries.map((e) => Chip(label: Text('${e.key}: ${e.value}'))).toList()),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () async {
            await ab.reset();
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Asignări A/B resetate')));
          },
          icon: const Icon(Icons.restart_alt),
          label: const Text('Resetează asignările'),
        ),
      ],
    );
  }
}
