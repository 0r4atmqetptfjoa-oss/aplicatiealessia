import 'package:flutter/material.dart';

class QuestsScreen extends StatelessWidget {
  const QuestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Exemplu de date - înlocuiește cu logica ta
    final quests = [
      {'name': 'Cântă 5 minute', 'progress': 0.5},
      {'name': 'Completează o poveste', 'progress': 0.0},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Misiuni'),
      ),
      body: ListView.builder(
        itemCount: quests.length,
        itemBuilder: (context, index) {
          final quest = quests[index];
          final progress = quest['progress'] as num;
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(quest['name'] as String),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: LinearProgressIndicator(value: progress.toDouble()),
              ),
            ),
          );
        },
      ),
    );
  }
}