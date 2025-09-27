import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/story_pack_service.dart';
import 'package:flutter/material.dart';

class StoryPackScreen extends StatelessWidget {
  const StoryPackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final svc = getIt<StoryPackService>();
    return Scaffold(
      appBar: AppBar(title: const Text('Pachete Povești (.alesia_story)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('Exportă pachet'),
            subtitle: const Text('Generează .alesia_story cu graful curent + mapări de asset-uri'),
            trailing: ElevatedButton(
              onPressed: () async {
                final f = await svc.exportPack(name: 'Pachet Poveste');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exportat: ${f.path}')));
                }
              },
              child: const Text('Export'),
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            title: const Text('Importă pachet'),
            subtitle: const Text('Încarcă un .alesia_story și actualizează povestea'),
            trailing: ElevatedButton(
              onPressed: () async {
                await svc.importPack();
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
