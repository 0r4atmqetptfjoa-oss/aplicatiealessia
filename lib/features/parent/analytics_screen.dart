import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final events = getIt<AnalyticsService>().events;
    final fmt = DateFormat('yyyy-MM-dd HH:mm:ss');
    return Scaffold(
      appBar: AppBar(title: const Text('Evenimente (local)')),
      body: events.isEmpty
          ? const Center(child: Text('Nu există evenimente încă.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: events.length,
              itemBuilder: (context, i) {
                final e = events[i];
                return ListTile(
                  leading: const Icon(Icons.bubble_chart),
                  title: Text(e.type),
                  subtitle: Text(e.data.toString()),
                  trailing: Text(fmt.format(DateTime.fromMillisecondsSinceEpoch(e.ts))),
                );
              },
              separatorBuilder: (_, __) => const Divider(height: 1),
            ),
    );
  }
}
