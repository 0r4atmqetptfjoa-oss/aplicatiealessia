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
