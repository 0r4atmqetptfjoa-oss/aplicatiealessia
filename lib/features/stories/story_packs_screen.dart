import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/story_pack_service.dart';
import 'package:flutter/material.dart';

class StoryPacksScreen extends StatelessWidget {
  const StoryPacksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pachete Povești')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('Exportă pachet poveste'),
            subtitle: const Text('Creează un fișier .alesia_story cu graful curent (JSON)'),
            trailing: ElevatedButton(
              onPressed: () async {
                final f = await getIt<StoryPackService>().exportPack();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exportat: ${f.path}')));
                }
              },
              child: const Text('Export'),
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            title: const Text('Importă pachet poveste'),
            subtitle: const Text('Selectează un fișier .alesia_story pentru a înlocui graful'),
            trailing: ElevatedButton(
              onPressed: () async {
                await getIt<StoryPackService>().importPack();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Import complet')));
                }
              },
              child: const Text('Import'),
            ),
          ),
        ],
      ),
    );
  }
}
