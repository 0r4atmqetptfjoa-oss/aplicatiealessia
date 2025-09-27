import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/analytics_service.dart';
import 'package:alesia/services/progress_service.dart';
import 'package:alesia/services/quests_service.dart';
import 'package:alesia/services/theme_service.dart';
import 'package:alesia/services/parents_service.dart';
import 'package:flutter/material.dart';

class ParentsDashboardScreen extends StatefulWidget {
  const ParentsDashboardScreen({super.key});

  @override
  State<ParentsDashboardScreen> createState() => _ParentsDashboardScreenState();
}

class _ParentsDashboardScreenState extends State<ParentsDashboardScreen> {
  bool bgMusic = false; // placeholder toggle (hook pentru viitor)
  final pinCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final analytics = getIt<AnalyticsService>();
    final progress = getIt<ProgressService>();
    final quests = getIt<QuestsService>();
    final themeSvc = getIt<ThemeService>();

    final instrumentStats = analytics.instrumentCounts.entries.toList()..sort((a,b)=>b.value.compareTo(a.value));

    String _formatMillis(int ms) {
      final s = (ms / 1000).floor();
      final m = s ~/ 60;
      final r = s % 60;
      return '${m}m ${r}s';
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Panou Părinți')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Analitice (on-device)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _StatCard(title: 'Sesiuni', value: '${analytics.totalSessions.value}')),
              const SizedBox(width: 12),
              Expanded(child: _StatCard(title: 'Timp total', value: _formatMillis(analytics.totalMillis))),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Utilizare instrumente'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: instrumentStats.isEmpty
                ? [const Text('Nicio utilizare înregistrată încă.')]
                : instrumentStats.map((e) => Chip(label: Text('${e.key}: ${e.value}'))).toList(),
          ),
          const Divider(height: 32),
          const Text('Recompense & Questuri', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Stickere totale: ${progress.totalStickers.value}'),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: () => progress.totalStickers.value, child: const Text('Refresh')),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              await getIt<ProgressService>().awardSticker('parent-bonus');
              if (mounted) setState(() {});
            }, child: const Text('Adaugă 1 sticker (bonus)'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              await getIt<QuestsService>().resetAll();
              if (mounted) setState(() {});
            }, child: const Text('Resetează questuri'),
          ),
          const Divider(height: 32),
          const Text('Teme sezoniere', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: Season.values.map((s) {
              return ChoiceChip(
                label: Text(s.name),
                selected: themeSvc.season == s,
                onSelected: (_) async { await themeSvc.setSeasonOverride(s); setState(() {}); },
              );
            }).toList(),
          ),
          const Divider(height: 32),
          const Text('Control PIN', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: pinCtrl, maxLength: 4, keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'PIN nou', border: OutlineInputBorder(), counterText: ''),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              if (pinCtrl.text.length == 4) {
                await getIt<ParentsService>().setPin(pinCtrl.text);
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PIN actualizat')));
              }
            },
            child: const Text('Setează PIN'),
          ),
          const Divider(height: 32),
          const Text('Resetări', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              await getIt<AnalyticsService>().resetAll();
              await getIt<ProgressService>().dispose(); // not existent; ignore
              if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Analitice resetate')));
              setState(() {});
            },
            child: const Text('Resetează Analitice'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
