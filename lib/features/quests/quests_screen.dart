import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/quests_service.dart';
import 'package:flutter/material.dart';

class QuestsScreen extends StatelessWidget {
  const QuestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final q = getIt<QuestsService>().quests;
    return Scaffold(
      appBar: AppBar(title: const Text('Questuri')),
      body: ListView.builder(
        itemCount: q.length,
        itemBuilder: (context, i) {
          final it = q[i];
          final progress = (it.progress / it.target).clamp(0, 1.0);
          return ListTile(
            title: Text(it.title),
            subtitle: LinearProgressIndicator(value: progress),
            trailing: it.completed ? const Icon(Icons.check_circle, color: Colors.green) : Text('${it.progress}/${it.target}'),
          );
        },
      ),
    );
  }
}
