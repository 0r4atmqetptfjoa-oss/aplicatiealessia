import 'package:flutter/material.dart';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/analytics_service.dart';
import 'package:alesia/services/progress_service.dart';
class AnalyticsDashboardScreen extends StatelessWidget {
  const AnalyticsDashboardScreen({super.key});
  @override Widget build(BuildContext context){
    final a=getIt<AnalyticsService>(); final p=getIt<ProgressService>(); final by=a.successCountsByInstrument();
    return ListView(padding: const EdgeInsets.all(16), children:[
      const Text('Sumar performanță', style: TextStyle(fontWeight: FontWeight.bold)),
      Wrap(spacing: 12, runSpacing: 12, children: by.entries.map((e)=>Chip(label: Text('${e.key}: ${e.value}'))).toList()),
      const Divider(height:32),
      const Text('Best Streak', style: TextStyle(fontWeight: FontWeight.bold)),
      Wrap(spacing:12, children:[Chip(label: Text('Pian: ${p.getBestStreak('piano')}')),Chip(label: Text('Tobe: ${p.getBestStreak('drums')}')),Chip(label: Text('Xilofon: ${p.getBestStreak('xylophone')}')),Chip(label: Text('Orgă: ${p.getBestStreak('organ')}'))]),
    ]);
  }
}


/// Bară simplă fără dependențe
class _Bar extends StatelessWidget {
  final String label;
  final int value;
  final int max;
  const _Bar({required this.label, required this.value, required this.max});

  @override
  Widget build(BuildContext context) {
    final ratio = max == 0 ? 0.0 : (value / max);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: $value'),
        const SizedBox(height: 4),
        Container(
          height: 10,
          decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(6)),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: ratio.clamp(0.0, 1.0),
            child: Container(decoration: BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(6))),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
