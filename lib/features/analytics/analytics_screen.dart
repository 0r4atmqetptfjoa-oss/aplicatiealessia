import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/analytics_service.dart';
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final a = getIt<AnalyticsService>();
    final counters = a.counters.entries.toList()..sort((a,b)=>a.key.compareTo(b.key));
    final timers = a.timers.entries.toList()..sort((a,b)=>a.key.compareTo(b.key));
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics (on-device)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Contoare', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...counters.map((e) => ListTile(title: Text(e.key), trailing: Text('${e.value}'))),
          const Divider(height: 32),
          const Text('Timp petrecut (ms cumulati)', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...timers.map((e) => ListTile(title: Text(e.key), trailing: Text('${e.value} ms'))),
        ],
      ),
    );
  }
}
