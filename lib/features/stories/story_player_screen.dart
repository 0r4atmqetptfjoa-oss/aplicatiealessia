import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/story_service.dart';
import 'package:alesia/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StoryPlayerScreen extends StatefulWidget {
  const StoryPlayerScreen({super.key});

  @override
  State<StoryPlayerScreen> createState() => _StoryPlayerScreenState();
}

class _StoryPlayerScreenState extends State<StoryPlayerScreen> {
  late Map<String, StoryNode> graph;
  String current = 'start';
  final history = <String>[];

  @override
  void initState() {
    super.initState();
    final ss = getIt<StoryService>();
    if (ss.graph.isEmpty) {
      ss.loadFromAssets();
    }
    graph = ss.graph;
    _playAudioOf(current);
  }

  Future<void> _playAudioOf(String id) async {
    final node = graph[id]!;
    if (node.audioId != null) {
      // TODO (Răzvan): pune naratorul în assets/audio/final/story_<id>.mp3
      await getIt<AudioService>().playNarrationId(node.audioId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final node = graph[current]!;
    return Scaffold(
      appBar: AppBar(title: const Text('Povești interactive')),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // TODO (Răzvan): Înlocuiește imaginea cu ilustrația secvenței curente 'assets/images/final/story_<id>.png'
          Expanded(child: Center(child: _StoryImage(nodeId: current)).animate().fadeIn()),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              node.subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ).animate().fadeIn(),
          ),
          Wrap(
            spacing: 12, runSpacing: 12, alignment: WrapAlignment.center,
            children: node.choices.map((c) => ElevatedButton(
              onPressed: () async {
                history.add(current);
                setState(() => current = c.nextId);
                await _playAudioOf(current);
              },
              child: Text(c.text),
            )).toList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _StoryImage extends StatelessWidget {
  final String nodeId;
  const _StoryImage({required this.nodeId});
  @override
  Widget build(BuildContext context) {
    final svc = getIt<StoryService>();
    final file = svc.imageFileForNode(nodeId);
    if (file != null && file.isNotEmpty) {
      return Image.file(File(file), fit: BoxFit.contain);
    }
    // TODO (Răzvan): Înlocuiește cu ilustrația finală 'story_$nodeId.png'
    return Image.asset('assets/images/placeholders/placeholder_landscape.png', fit: BoxFit.contain);
  }
}
