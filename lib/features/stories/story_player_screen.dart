import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/audio_service.dart';
import 'package:alesia/features/stories/story_engine.dart';

class StoryPlayerScreen extends StatefulWidget {
  final String? jsonScenario;
  const StoryPlayerScreen({super.key, this.jsonScenario});

  @override
  State<StoryPlayerScreen> createState() => _StoryPlayerScreenState();
}

class _StoryPlayerScreenState extends State<StoryPlayerScreen> {
  late StoryGraph graph;
  String current = 'start';
  final history = <String>[];

  @override
  void initState() {
    super.initState();
    if (widget.jsonScenario != null) {
      graph = StoryGraph.fromJson(json.decode(widget.jsonScenario!));
    } else {
      graph = _defaultGraph();
    }
    _playAudioOf(current);
  }

  StoryGraph _defaultGraph() {
    final nodes = {
      'start': StoryNode(id: 'start', subtitle: 'A fost odată ca niciodată...', audioId: 'story_start', choices: [StoryChoice('Spre castel', 'castle'), StoryChoice('Spre pădure', 'forest')]),
      'castle': StoryNode(id: 'castle', subtitle: 'La castel, muzica răsuna în sala mare.', audioId: 'story_castle', choices: [StoryChoice('Dansează', 'dance'), StoryChoice('Înapoi', 'start')]),
      'forest': StoryNode(id: 'forest', subtitle: 'În pădure, păsărelele ciripeau vesel.', audioId: 'story_forest', choices: [StoryChoice('Ascultă păsările', 'birds'), StoryChoice('Înapoi', 'start')]),
      'dance': StoryNode(id: 'dance', subtitle: 'Toți prietenii s-au prins în horă!', audioId: 'story_dance', choices: [StoryChoice('Final fericit', 'end')]),
      'birds': StoryNode(id: 'birds', subtitle: 'Cântecul lor te-a făcut să zâmbești.', audioId: 'story_birds', choices: [StoryChoice('Final fericit', 'end')]),
      'end': StoryNode(id: 'end', subtitle: 'Și-am încălecat pe-o șa... Sfârșit!', audioId: 'story_end', choices: [StoryChoice('Reia povestea', 'start')]),
    };
    return StoryGraph(nodes);
  }

  Future<void> _playAudioOf(String id) async {
    final node = graph[id]!;
    if (node.audioId != null) {
      // TODO (Răzvan): pune naratorul în assets/audio/final/story_<id>.mp3
      await getIt<AudioService>().playNote(node.audioId!);
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
          Expanded(child: Center(
            child: Image.asset(
              // TODO (Răzvan): Înlocuiește cu ilustrația nodului curent (dacă node.image != null)
              'assets/images/placeholders/placeholder_landscape.png',
              fit: BoxFit.cover,
            ),
          ).animate().fadeIn()),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(node.subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)).animate().fadeIn(),
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
