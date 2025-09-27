import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/quests_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class QuestsScreen extends StatelessWidget {
  const QuestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final svc = getIt<QuestsService>();
    return Scaffold(
      appBar: AppBar(title: const Text('Questuri')),
      body: ValueListenableBuilder<List<Quest>>(
        valueListenable: svc.quests,
        builder: (context, list, _) {
          if (list.isEmpty) {
            return const Center(child: Text('Nicio misiune disponibilă.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final q = list[i];
              final pct = (q.progress / q.goal).clamp(0, 1).toDouble();
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(q.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(value: pct),
                      const SizedBox(height: 8),
                      Text('${q.progress}/${q.goal}'),
                      if (q.completed) const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text('Completat! 🎉', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ).animate().fade().slideY(begin: 0.1);
            },
          );
        },
      ),
    );
  }
}
