import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StoryNode {
  final String id;
  final String subtitle;
  final String? audioId;
  final List<StoryChoice> choices;
  StoryNode({required this.id, required this.subtitle, this.audioId, this.choices = const []});

  Map<String, dynamic> toJson() => {
    'id': id,
    'subtitle': subtitle,
    'audioId': audioId,
    'choices': choices.map((c) => c.toJson()).toList(),
  };

  static StoryNode fromJson(Map<String, dynamic> m) => StoryNode(
    id: m['id'],
    subtitle: m['subtitle'] ?? '',
    audioId: m['audioId'],
    choices: (m['choices'] as List? ?? []).map((e) => StoryChoice.fromJson(Map<String, dynamic>.from(e))).toList(),
  );
}

class StoryChoice {
  final String text;
  final String nextId;
  StoryChoice(this.text, this.nextId);
  Map<String, dynamic> toJson() => {'text': text, 'nextId': nextId};
  static StoryChoice fromJson(Map<String, dynamic> m) => StoryChoice(m['text'] ?? '', m['nextId'] ?? '');
}

class StoryService {
  static const _k = 'story_graph_json';
  Map<String, StoryNode> _graph = {};
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs!.getString(_k);
    if (raw == null) {
      _graph = _defaultGraph();
      await _persist();
    } else {
      setGraphFromJson(raw);
    }
  }

  Map<String, StoryNode> get graph => _graph;
  String get graphJson => json.encode(_graph.map((k, v) => MapEntry(k, v.toJson())));

  Future<void> setGraphFromJson(String raw) async {
    final m = Map<String, dynamic>.from(json.decode(raw));
    final g = <String, StoryNode>{};
    m.forEach((k, v) => g[k] = StoryNode.fromJson(Map<String, dynamic>.from(v)));
    _graph = g;
    await _persist();
  }

  Future<void> _persist() async {
    await _prefs?.setString(_k, graphJson);
  }

  Map<String, StoryNode> _defaultGraph() {
    return {
      'start': StoryNode(
        id: 'start', subtitle: 'A fost odată ca niciodată...', audioId: 'story_start',
        choices: [StoryChoice('Spre castel', 'castle'), StoryChoice('Spre pădure', 'forest')],
      ),
      'castle': StoryNode(
        id: 'castle', subtitle: 'La castel, muzica răsuna în sala mare.', audioId: 'story_castle',
        choices: [StoryChoice('Dansează', 'dance'), StoryChoice('Înapoi', 'start')],
      ),
      'forest': StoryNode(
        id: 'forest', subtitle: 'În pădure, păsărelele ciripeau vesel.', audioId: 'story_forest',
        choices: [StoryChoice('Ascultă păsările', 'birds'), StoryChoice('Înapoi', 'start')],
      ),
      'dance': StoryNode(
        id: 'dance', subtitle: 'Toți prietenii s-au prins în horă!', audioId: 'story_dance',
        choices: [StoryChoice('Final fericit', 'end')],
      ),
      'birds': StoryNode(
        id: 'birds', subtitle: 'Cântecul lor te-a făcut să zâmbești.', audioId: 'story_birds',
        choices: [StoryChoice('Final fericit', 'end')],
      ),
      'end': StoryNode(
        id: 'end', subtitle: 'Și-am încălecat pe-o șa... Sfârșit!', audioId: 'story_end',
        choices: [StoryChoice('Reia povestea', 'start')],
      ),
    };
  }
}
