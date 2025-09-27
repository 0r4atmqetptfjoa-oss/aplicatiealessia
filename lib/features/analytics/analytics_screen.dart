import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/parental_service.dart';
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final analytics = getIt<AnalyticsService>();
    final entries = analytics.counters.entries.toList()..sort((a,b)=>a.key.compareTo(b.key));
    return Scaffold(
      appBar: AppBar(title: const Text('Analitice on-device')),
      body: entries.isEmpty
        ? const Center(child: Text('Nicio activitate înregistrată încă.'))
        : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (_, i) {
              final e = entries[i];
              return ListTile(
                title: Text(e.key),
                trailing: Text(e.value.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
              );
            },
            separatorBuilder: (_, __) => const Divider(),
            itemCount: entries.length,
          ),
    );
  }
}
