import 'dart:math';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/analytics_service.dart';
import 'package:alesia/services/profile_service.dart';
import 'package:flutter/material.dart';

enum Period { last7, last14, last30 }

class Heatmap7x24Screen extends StatefulWidget {
  const Heatmap7x24Screen({super.key});

  @override
  State<Heatmap7x24Screen> createState() => _Heatmap7x24ScreenState();
}

class _Heatmap7x24ScreenState extends State<Heatmap7x24Screen> {
  final instruments = const ['piano','drums','xylophone','organ','all'];
  String inst = 'all';
  Period period = Period.last7;

  @override
  Widget build(BuildContext context) {
    final an = getIt<AnalyticsService>();
    final profId = getIt<ProfileService>().activeId.value;
    final now = DateTime.now();

    int days = switch (period) { Period.last7 => 7, Period.last14 => 14, Period.last30 => 30 };
    // 7 rows (last 7 days) aggregated from chosen period
    final grid = List.generate(7, (_) => List.filled(24, 0));
    for (final e in an.events) {
      if (e.type != 'coach_success') continue;
      if (inst != 'all' && e.data['instrument'] != inst) continue;
      if (profId != null && e.data['profileId'] != profId) continue;
      final dt = DateTime.fromMillisecondsSinceEpoch(e.ts);
      final diff = now.difference(DateTime(dt.year, dt.month, dt.day)).inDays;
      if (diff >= 0 && diff < days) {
        final row = 6 - (diff % 7);
        grid[row][dt.hour] += 1;
      }
    }
    int maxv = 1;
    for (final row in grid) { maxv = max(maxv, row.fold(0, (a,b)=>max(a,b))); }

    return Scaffold(
      appBar: AppBar(title: const Text('Heatmap 7×24')),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              DropdownButton<String>(
                value: inst,
                items: instruments.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => inst = v!),
              ),
              DropdownButton<Period>(
                value: period,
                items: const [
                  DropdownMenuItem(value: Period.last7, child: Text('Ultimele 7 zile')),
                  DropdownMenuItem(value: Period.last14, child: Text('Ultimele 14 zile')),
                  DropdownMenuItem(value: Period.last30, child: Text('Ultima lună')),
                ],
                onChanged: (v) => setState(() => period = v!),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: _Grid(grid: grid, maxv: maxv),
            ),
          ),
        ],
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  final List<List<int>> grid; // 7 x 24
  final int maxv;
  const _Grid({required this.grid, required this.maxv});

  @override
  Widget build(BuildContext context) {
    final days = ['L','Ma','Mi','J','V','S','D'];
    return Column(
      children: [
        Row(children: List.generate(25, (i) => Expanded(child: i==0?const SizedBox():Center(child: Text('${i-1}', style: const TextStyle(fontSize: 12)))))),
        Expanded(
          child: Row(
            children: [
              // days labels
              Column(children: List.generate(7, (r) => Expanded(child: Center(child: Text(days[r]))))),
              const SizedBox(width: 6),
              // cells
              Expanded(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 24, crossAxisSpacing: 2, mainAxisSpacing: 2),
                  itemCount: 7*24,
                  itemBuilder: (context, idx) {
                    final r = idx ~/ 24;
                    final c = idx % 24;
                    final v = grid[r][c];
                    final t = (v / (maxv==0?1:maxv)).clamp(0.0, 1.0);
                    final col = Color.lerp(Colors.white, Colors.deepPurple, t)!;
                    return Container(decoration: BoxDecoration(color: col.withOpacity(0.9), borderRadius: BorderRadius.circular(2)));
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
