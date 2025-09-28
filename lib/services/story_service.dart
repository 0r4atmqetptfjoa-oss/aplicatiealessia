import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:flutter/services.dart' show rootBundle;

class Story {
  Story({required this.id, required this.title, required this.nodes, this.startNodeId});
  final String id;
  final String title;
  final Map<String, StoryNode> nodes;
  final String? startNodeId;

  StoryNode? get start => startNodeId != null ? nodes[startNodeId] : null;
}

class StoryNode {
  StoryNode({
    required this.id,
    required this.text,
    this.imagePath,
    this.audioPath,
    List<StoryChoice>? choices,
  }) : choices = choices ?? <StoryChoice>[];

  final String id;
  final String text;
  final String? imagePath;
  final String? audioPath;
  final List<StoryChoice> choices;
}

class StoryChoice {
  final String text;
  final String nextId;
  const StoryChoice({required this.text, required this.nextId});
}

class StoryService {
  /// Loads an interactive story from a ZIP asset that contains `story.json`
  /// and optional media files referenced by relative paths.
  Future<Story> loadStory(String storyAssetPath) async {
    final data = await rootBundle.load(storyAssetPath);
    final bytes = data.buffer.asUint8List();
    final archive = ZipDecoder().decodeBytes(bytes);

    // Find story.json entry
    final storyEntry = archive.files.firstWhere(
      (f) => f.name.endsWith('story.json'),
      orElse: () => throw StateError('story.json not found in $storyAssetPath'),
    );

    final jsonStr = utf8.decode(storyEntry.content as List<int>);
    final map = json.decode(jsonStr) as Map<String, dynamic>;

    final id = (map['id'] ?? 'story') as String;
    final title = (map['title'] ?? 'Story') as String;
    final startId = map['start'] as String?;

    final nodesMap = <String, StoryNode>{};
    final nodesJson = Map<String, dynamic>.from(map['nodes'] as Map);
    nodesJson.forEach((nodeId, rawNode) {
      final n = Map<String, dynamic>.from(rawNode as Map);
      final choicesJson = (n['choices'] as List? ?? const [])
          .map((c) => StoryChoice(text: c['text'] as String, nextId: c['nextId'] as String))
          .toList();
      nodesMap[nodeId] = StoryNode(
        id: nodeId,
        text: (n['text'] ?? '') as String,
        imagePath: n['image'] as String?,
        audioPath: n['audio'] as String?,
        choices: choicesJson,
      );
    });

    return Story(id: id, title: title, nodes: nodesMap, startNodeId: startId);
  }

  /// Helper to extract raw bytes from a file inside the same ZIP bundle.
  Uint8List? extractBytes(Archive archive, String relativePath) {
    final entry = archive.files.firstWhere(
      (f) => f.name == relativePath,
      orElse: () => ArchiveFile('missing', 0, null),
    );
    if (entry.content == null) return null;
    final data = entry.content;
    if (data is List<int>) return Uint8List.fromList(data);
    if (data is Uint8List) return data;
    return null;
  }
}
