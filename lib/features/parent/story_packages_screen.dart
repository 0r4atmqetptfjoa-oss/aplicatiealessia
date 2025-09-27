import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/story_package_service.dart';
import 'package:flutter/material.dart';

class StoryPackagesScreen extends StatelessWidget {
  const StoryPackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final svc = getIt<StoryPackageService>();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ListTile(
            title: const Text('Exportă pachet .alesia_story'),
            subtitle: const Text('Include story.json + manifest'),
            trailing: ElevatedButton(
              onPressed: () async {
                final f = await svc.exportPackage();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exportat: ${f.path}')));
                }
              },
              child: const Text('Export'),
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            title: const Text('Importă pachet .alesia_story'),
            subtitle: const Text('Aplică story.json și extrage media în Documents/stories/'),
            trailing: ElevatedButton(
              onPressed: () async {
                await svc.importPackage();
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
