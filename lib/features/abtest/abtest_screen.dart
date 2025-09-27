import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/ab_test_service.dart';
import 'package:flutter/material.dart';

class ABTestScreen extends StatefulWidget {
  const ABTestScreen({super.key});
  @override
  State<ABTestScreen> createState() => _ABTestScreenState();
}

class _ABTestScreenState extends State<ABTestScreen> {
  @override
  Widget build(BuildContext context) {
    final ab = getIt<ABTestService>();
    final assignments = ab.assignments;
    final metrics = ab.metrics;
    final keys = {'visualizer_style','particles','button_bounce', ...assignments.keys, ...metrics.keys}.toList();
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: keys.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, i) {
        final k = keys[i];
        final cur = ab.getVariant(k);
        final m = metrics[k] ?? {'A':0,'B':0};
        return ListTile(
          title: Text(k),
          subtitle: Text('A: ${m['A'] ?? 0}  |  B: ${m['B'] ?? 0}'),
          trailing: SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'A', label: Text('A')),
              ButtonSegment(value: 'B', label: Text('B')),
            ],
            selected: {cur},
            onSelectionChanged: (s) => setState(() => ab.setVariant(k, s.first)),
          ),
        );
      },
    );
  }
}
