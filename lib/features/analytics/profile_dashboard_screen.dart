import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/analytics_service.dart';
import 'package:alesia/services/profile_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProfileDashboardScreen extends StatelessWidget {
  const ProfileDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final an = getIt<AnalyticsService>();
    final prof = getIt<ProfileService>().active;
    final now = DateTime.now();

    List<int> bucket(int startDaysAgo) {
      final res = List.filled(7, 0);
      for (final e in an.events) {
        if (e.type != 'coach_success') continue;
        final pid = e.data['profileId'];
        if (prof != null && pid != null && pid != prof.id) continue;
        final dt = DateTime.fromMillisecondsSinceEpoch(e.ts);
        final diff = now.difference(DateTime(dt.year, dt.month, dt.day)).inDays;
        if (diff >= startDaysAgo && diff < startDaysAgo + 7) {
          final idx = 6 - (diff - startDaysAgo);
          res[idx] += 1;
        }
      }
      return res;
    }

    final thisWeek = bucket(0).asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.toDouble())).toList();
    final lastWeek = bucket(7).asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.toDouble())).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Profil: ${prof?.name ?? '—'}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Reușite pe săptămâni', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            AspectRatio(
              aspectRatio: 1.6,
              child: LineChart(LineChartData(
                lineBarsData: [
                  LineChartBarData(spots: lastWeek, isCurved: true, color: Colors.grey, barWidth: 3, dashArray: [8,4], dotData: const FlDotData(show: false)),
                  LineChartBarData(spots: thisWeek, isCurved: true, color: Colors.deepPurple, barWidth: 3, dotData: const FlDotData(show: false)),
                ],
                minY: 0,
                titlesData: const FlTitlesData(show: false),
                gridData: const FlGridData(show: true),
                borderData: FlBorderData(show: true),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
