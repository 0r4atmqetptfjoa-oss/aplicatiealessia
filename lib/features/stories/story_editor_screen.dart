import 'dart:convert';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/story_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class StoryEditorScreen extends StatefulWidget {
  const StoryEditorScreen({super.key});

  @override
  State<StoryEditorScreen> createState() => _StoryEditorScreenState();
}

class _StoryEditorScreenState extends State<StoryEditorScreen> {
  late TextEditingController _controller;
  bool _valid = true;

  @override
  void initState() {
    super.initState();
    final s = getIt<StoryService>();
    _controller = TextEditingController(text: const JsonEncoder.withIndent('  ').convert(s.graph.map((k, v) => MapEntry(k, v.toJson()))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editor Povești (JSON)')),
      body: Column(
        children: [
          Row(
            children: [
              TextButton.icon(onPressed: _importJson, icon: const Icon(Icons.file_open), label: const Text('Import')),
              const SizedBox(width: 8),
              TextButton.icon(onPressed: _exportJson, icon: const Icon(Icons.save_alt), label: const Text('Export')),
              const SizedBox(width: 8),
              ElevatedButton.icon(onPressed: _apply, icon: const Icon(Icons.check), label: const Text('Aplică')),
              const SizedBox(width: 8),
              if (!_valid) const Text('JSON invalid', style: TextStyle(color: Colors.red)),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                expands: true,
                maxLines: null,
                minLines: null,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(fontFamily: 'monospace'),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _apply() async {
    try {
      final raw = _controller.text;
      json.decode(raw); // validate
      await getIt<StoryService>().setGraphFromJson(raw);
      if (mounted) setState(() => _valid = true);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Poveste actualizată.')));
    } catch (_) {
      if (mounted) setState(() => _valid = false);
    }
  }

  Future<void> _importJson() async {
    final res = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['json']);
    if (res == null || res.files.isEmpty) return;
    final raw = await res.files.single.xFile.readAsString();
    setState(() => _controller.text = raw);
  }

  Future<void> _exportJson() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/Story_${DateTime.now().millisecondsSinceEpoch}.json';
    final f = await XFile(path).writeAsString(_controller.text);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exportat: $path')));
  }
}
