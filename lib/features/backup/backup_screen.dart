import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/backup_service.dart';
import 'package:flutter/material.dart';

class BackupScreen extends StatelessWidget {
  const BackupScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Backup & Restore')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('Exportă setări & progres'),
            subtitle: const Text('Creează un fișier .alesia în Documents'),
            trailing: ElevatedButton(
              onPressed: () async {
                final f = await getIt<BackupService>().exportToFile();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exportat: ${f.path}')));
                }
              },
              child: const Text('Export'),
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            title: const Text('Importă din fișier .alesia'),
            subtitle: const Text('Selectează un fișier de backup pentru restaurare'),
            trailing: ElevatedButton(
              onPressed: () async {
                await getIt<BackupService>().restoreFromFile();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Restore complet')));
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
