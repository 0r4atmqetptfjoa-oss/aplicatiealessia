import 'dart:io';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/story_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StoryEditorScreen extends StatefulWidget {
  const StoryEditorScreen({super.key});

  @override
  State<StoryEditorScreen> createState() => _StoryEditorScreenState();
}

class _StoryEditorScreenState extends State<StoryEditorScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final ss = getIt<StoryService>();
    if (ss.graph.isEmpty) {
      ss.loadFromAssets();
    }
    _controller = TextEditingController(text: ss.toJsonString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stories JSON Editor')),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'JSON story...'),
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
          ),
          Wrap(
            spacing: 12, runSpacing: 12,
            children: [
              ElevatedButton.icon(onPressed: _validate, icon: const Icon(Icons.check), label: const Text('Validare')).animate().scale(),
              ElevatedButton.icon(onPressed: _import, icon: const Icon(Icons.file_open), label: const Text('Import')).animate().scale(),
              ElevatedButton.icon(onPressed: _export, icon: const Icon(Icons.save_alt), label: const Text('Export')).animate().scale(),
              ElevatedButton.icon(onPressed: _applyAndPreview, icon: const Icon(Icons.play_arrow), label: const Text('Aplică & Preview')).animate().scale(),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  void _validate() {
    try {
      getIt<StoryService>().setFromJsonString(_controller.text);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('JSON valid ✅')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Eroare JSON: $e')));
    }
  }

  Future<void> _import() async {
    final res = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['json']);
    if (res == null || res.files.isEmpty) return;
    final file = File(res.files.single.path!);
    final txt = await file.readAsString();
    setState(() { _controller.text = txt; });
  }

  Future<void> _export() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/story_${DateTime.now().millisecondsSinceEpoch}.json';
      await File(path).writeAsString(_controller.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exportat: $path')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Eroare export: $e')));
      }
    }
  }

  void _applyAndPreview() {
    try {
      getIt<StoryService>().setFromJsonString(_controller.text);
      Navigator.of(context).pushNamed('/povesti'); // redă în player
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fix JSON înainte de preview: $e')));
    }
  }
}
