import 'dart:math';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/analytics_service.dart';
import 'package:alesia/services/profile_service.dart';
import 'package:flutter/material.dart';

class InstrumentHeatmapScreen extends StatefulWidget {
  const InstrumentHeatmapScreen({super.key});

  @override
  State<InstrumentHeatmapScreen> createState() => _InstrumentHeatmapScreenState();
}

class _InstrumentHeatmapScreenState extends State<InstrumentHeatmapScreen> {
  late String selected;
  final instruments = const ['piano','drums','xylophone','organ'];

  @override
  void initState() {
    super.initState();
    selected = instruments.first;
  }

  @override
  Widget build(BuildContext context) {
    final an = getIt<AnalyticsService>();
    final profId = getIt<ProfileService>().activeId.value;

    final counts = List.filled(24, 0);
    for (final e in an.events) {
      if (e.type != 'coach_success') continue;
      if (e.data['instrument'] != selected) continue;
      if (profId != null && e.data['profileId'] != profId) continue;
      final dt = DateTime.fromMillisecondsSinceEpoch(e.ts);
      counts[dt.hour] += 1;
    }
    final maxv = (counts.isEmpty?1:counts.reduce(max)).clamp(1, 999);

    return Scaffold(
      appBar: AppBar(title: const Text('Heatmap pe ore (profil curent)')),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Wrap(spacing: 8, children: instruments.map((k) => ChoiceChip(
            label: Text(k),
            selected: selected == k,
            onSelected: (_) => setState(() => selected = k),
          )).toList()),
          const SizedBox(height: 12),
          Expanded(child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: _HourHeatmap(counts: counts, maxv: maxv),
          )),
        ],
      ),
    );
  }
}

class _HourHeatmap extends StatelessWidget {
  final List<int> counts;
  final int maxv;
  const _HourHeatmap({required this.counts, required this.maxv});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: 24,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6, crossAxisSpacing: 6, mainAxisSpacing: 6, childAspectRatio: 1.6,
      ),
      itemBuilder: (context, i) {
        final v = counts[i];
        final t = v / (maxv==0?1:maxv);
        final col = Color.lerp(Colors.white, Colors.deepPurple, t)!;
        return Container(
          decoration: BoxDecoration(color: col.withOpacity(0.85), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black12)),
          child: Center(child: Text('$i
$v', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))),
        );
      },
    );
  }
}
