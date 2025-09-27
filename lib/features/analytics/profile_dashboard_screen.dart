import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/analytics_service.dart';
import 'package:alesia/services/profile_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProfileDashboardScreen extends StatelessWidget {
  const ProfileDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final a = getIt<AnalyticsService>();
    final prof = getIt<ProfileService>();
    final active = prof.activeId.value;

    final thisWeek = _seriesByDay(a, active, 0);
    final prevWeek = _seriesByDay(a, active, 7);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Profil activ: ${prof.active?.name ?? '-'}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        AspectRatio(
          aspectRatio: 1.6,
          child: LineChart(LineChartData(
            lineBarsData: [
              _line(prevWeek, Colors.grey),
              _line(thisWeek, Colors.deepPurple),
            ],
            minY: 0,
            titlesData: const FlTitlesData(show: false),
            gridData: const FlGridData(show: true),
            borderData: FlBorderData(show: true),
          )),
        ),
        const SizedBox(height: 8),
        const Text('Gri = săptămâna precedentă · Mov = săptămâna curentă'),
      ],
    );
  }

  List<FlSpot> _seriesByDay(AnalyticsService a, String? profileId, int offsetDays) {
    final now = DateTime.now().subtract(Duration(days: offsetDays));
    final start = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6));
    final buckets = List<int>.filled(7, 0);
    for (final e in a.events) {
      if (e.type != 'coach_success') continue;
      final pid = e.data['profileId']?.toString();
      if (pid != null && profileId != null && pid != profileId) continue;
      final dt = DateTime.fromMillisecondsSinceEpoch(e.ts);
      if (dt.isBefore(start) || dt.isAfter(DateTime(now.year, now.month, now.day, 23, 59, 59))) continue;
      final idx = dt.difference(start).inDays.clamp(0, 6);
      buckets[idx] += 1;
    }
    return List<FlSpot>.generate(7, (i) => FlSpot(i.toDouble(), buckets[i].toDouble()));
  }

  LineChartBarData _line(List<FlSpot> spots, Color c) => LineChartBarData(
    isCurved: true, color: c, barWidth: 3, dotData: const FlDotData(show: false), spots: spots);
}