import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:alesia/features/stories/story_player_screen.dart';

class StoryJsonEditorScreen extends StatefulWidget {
  const StoryJsonEditorScreen({super.key});
  @override
  State<StoryJsonEditorScreen> createState() => _StoryJsonEditorScreenState();
}

class _StoryJsonEditorScreenState extends State<StoryJsonEditorScreen> {
  final controller = TextEditingController(text: '{"nodes": []}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editor JSON Povești')),
      body: Column(
        children: [
          Expanded(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              maxLines: null,
              expands: true,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'JSON scenariu (StoryGraph)'),
            ),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(onPressed: _import, child: const Text('Importă JSON')),
              const SizedBox(width: 8),
              OutlinedButton(onPressed: _export, child: const Text('Exportă JSON')),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: _preview, child: const Text('Previzualizează')),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Future<void> _import() async {
    final res = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['json']);
    if (res == null || res.files.isEmpty) return;
    final bytes = res.files.single.bytes ?? await res.files.single.readStream!.fold<List<int>>([], (a, b) { a.addAll(b); return a; });
    controller.text = utf8.decode(bytes);
    setState(() {});
  }

  Future<void> _export() async {
    try {
      json.decode(controller.text); // validate
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('JSON invalid: $e')));
      return;
    }
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/story_${DateTime.now().millisecondsSinceEpoch}.json';
    final f = await File(path).writeAsString(controller.text);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Salvat: ${f.path}')));
  }

  void _preview() {
    try { json.decode(controller.text); } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('JSON invalid: $e'))); return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => StoryPlayerScreen(jsonScenario: controller.text)));
  }
}
