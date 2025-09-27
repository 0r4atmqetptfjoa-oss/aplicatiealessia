import 'dart:convert';
import 'dart:io';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/features/parent/story_link_minigame.dart';
import 'package:alesia/services/story_package_models.dart';
import 'package:alesia/services/story_service.dart';
import 'package:flutter/material.dart';

class StoryPackagePreviewScreen extends StatelessWidget {
  final StoryPackagePreview preview;
  const StoryPackagePreviewScreen({super.key, required this.preview});

  @override
  Widget build(BuildContext context) {
    final missingI = preview.imagesMissing;
    final missingA = preview.audioMissing;

    return Scaffold(
      appBar: AppBar(title: const Text('Preview Pachet Poveste')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (preview.storyJson != null)
            Card(child: ListTile(
              title: const Text('story.json'),
              subtitle: Text('${json.decode(preview.storyJson!).keys.length} noduri (aprox.)'),
            )),
          const SizedBox(height: 8),
          Text('Imagini găsite: ${preview.imagesFound.length}'),
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: preview.imagesFound.map((p) {
                final f = File('${preview.tempDirPath}/' + p);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Image.file(f, height: 120, errorBuilder: (_, __, ___) => const SizedBox(width: 120)),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Text('Audio găsit: ${preview.audioFound.length}'),
          Wrap(spacing: 8, children: preview.audioFound.map((p) => Chip(label: Text(p))).toList()),
          const Divider(height: 32),
          if (preview.imagesExpected.isNotEmpty || preview.audioExpected.isNotEmpty) ...[
            const Text('Validare după manifest', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (preview.imagesExpected.isNotEmpty) Text('Imagini așteptate: ${preview.imagesExpected.join(', ')}'),
            if (missingI.isNotEmpty) Text('Imagini lipsă: ${missingI.join(', ')}', style: TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            if (preview.audioExpected.isNotEmpty) Text('Audio așteptat: ${preview.audioExpected.join(', ')}'),
            if (missingA.isNotEmpty) Text('Audio lipsă: ${missingA.join(', ')}', style: TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: preview.storyJson == null ? null : () async {
              await getIt<StoryService>().setGraphFromJson(preview.storyJson!);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Poveste aplicată')));
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.check),
            label: const Text('Aplică această poveste'),
          ),
          const SizedBox(height: 12),
          // Mini-joc de validare link-uri (quiz)
          StoryLinkMiniGame(graph: getIt<StoryService>().graph),
        ],
      ),
    );
  }
}
