import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/analytics_service.dart';
import 'package:alesia/services/profile_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProfileDashboardScreen extends StatelessWidget {
  const ProfileDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prof = getIt<ProfileService>().active;
    final a = getIt<AnalyticsService>();
    final weekly = _weeklyByInstrument(a, profileId: prof?.id);

    return Scaffold(
      appBar: AppBar(title: Text('Dashboard profil: ${prof?.name ?? '—'}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Reușite săptămâna curentă vs. precedentă', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: BarChart(BarChartData(
                barGroups: _toGroups(weekly),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, meta) {
                    switch (v.toInt()) {
                      case 0: return const Text('Pian');
                      case 1: return const Text('Tobe');
                      case 2: return const Text('Xilo');
                      case 3: return const Text('Orgă');
                    }
                    return const Text('');
                  })),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: true),
                borderData: FlBorderData(show: true),
                barTouchData: BarTouchData(enabled: true),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, List<int>> _weeklyByInstrument(AnalyticsService a, {String? profileId}) {
    final now = DateTime.now();
    final startThisWeek = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday % 7));
    final startPrevWeek = startThisWeek.subtract(const Duration(days: 7));
    final endPrevWeek = startThisWeek;
    final endThisWeek = startThisWeek.add(const Duration(days: 7));

    final map = {
      'piano': [0, 0],
      'drums': [0, 0],
      'xylophone': [0, 0],
      'organ': [0, 0],
    };

    for (final e in a.events) {
      if (e.type != 'coach_success') continue;
      if (profileId != null && (e.data['profile']?.toString() ?? '') != profileId) continue;
      final dt = DateTime.fromMillisecondsSinceEpoch(e.ts);
      final inst = e.data['instrument']?.toString() ?? 'unknown';
      if (!map.containsKey(inst)) continue;
      if (dt.isAfter(startPrevWeek) && dt.isBefore(endPrevWeek)) {
        map[inst]![0] += 1; // prev week
      } else if (dt.isAfter(startThisWeek) && dt.isBefore(endThisWeek)) {
        map[inst]![1] += 1; // this week
      }
    }
    return map;
  }

  List<BarChartGroupData> _toGroups(Map<String, List<int>> m) {
    int idx = 0;
    final groups = <BarChartGroupData>[];
    for (final key in ['piano','drums','xylophone','organ']) {
      final v = m[key]!;
      groups.add(BarChartGroupData(
        x: idx++,
        barRods: [
          BarChartRodData(toY: v[0].toDouble(), color: Colors.grey),
          BarChartRodData(toY: v[1].toDouble(), color: Colors.deepPurple),
        ],
        barsSpace: 6,
      ));
    }
    return groups;
  }
}