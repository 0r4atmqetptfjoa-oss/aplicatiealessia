import 'dart:io';
import 'package:alesia/services/backup_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  String? _lastExportPath;
  final _svc = BackupService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton.icon(
            onPressed: () async {
              final p = await _svc.exportToFile();
              setState(() => _lastExportPath = p);
              if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup salvat: $p')));
            },
            icon: const Icon(Icons.save),
            label: const Text('Exportă backup (.alesia)'),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              final res = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['alesia']);
              if (res != null && res.files.single.path != null) {
                final file = File(res.files.single.path!);
                await _svc.importFromFile(file);
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup importat!')));
              }
            },
            icon: const Icon(Icons.upload_file),
            label: const Text('Importă backup'),
          ),
          if (_lastExportPath != null) ...[
            const SizedBox(height: 12),
            Text('Ultimul backup: $_lastExportPath'),
          ]
        ],
      ),
    );
  }
}
