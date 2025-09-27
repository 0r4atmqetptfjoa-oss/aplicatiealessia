import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/quest_service.dart';
import 'package:flutter/material.dart';

class QuestsScreen extends StatelessWidget {
  const QuestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final svc = getIt<QuestService>();
    final quests = svc.quests;
    return Scaffold(
      appBar: AppBar(title: const Text('Questuri')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: quests.length,
        itemBuilder: (context, i) {
          final q = quests[i];
          return ListTile(
            leading: Icon(q.completed ? Icons.emoji_events : Icons.flag, color: q.completed ? Colors.amber : null),
            title: Text(q.title),
            subtitle: Text('Instrument: ${q.instrument} — Țintă: ${q.target}, Progres: ${q.progress}'),
            trailing: q.completed ? const Text('Complet') : null,
          );
        },
        separatorBuilder: (_, __) => const Divider(height: 1),
      ),
    );
  }
}
