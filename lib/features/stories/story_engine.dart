class StoryNode {
  final String id;
  final String subtitle;
  final String? image; // assets/images/final/...
  final String? audioId; // assets/audio/final/story_<id>.mp3
  final List<StoryChoice> choices;

  StoryNode({required this.id, required this.subtitle, this.image, this.audioId, this.choices = const []});

  Map<String, dynamic> toJson() => {
    'id': id, 'subtitle': subtitle, 'image': image, 'audioId': audioId,
    'choices': choices.map((c) => c.toJson()).toList(),
  };

  static StoryNode fromJson(Map<String, dynamic> m) => StoryNode(
    id: m['id'], subtitle: m['subtitle'], image: m['image'], audioId: m['audioId'],
    choices: (m['choices'] as List? ?? []).map((e) => StoryChoice.fromJson(Map<String, dynamic>.from(e))).toList(),
  );
}

class StoryChoice {
  final String text;
  final String nextId;
  StoryChoice(this.text, this.nextId);

  Map<String, dynamic> toJson() => {'text': text, 'nextId': nextId};
  static StoryChoice fromJson(Map<String, dynamic> m) => StoryChoice(m['text'], m['nextId']);
}

class StoryGraph {
  final Map<String, StoryNode> nodes;
  StoryGraph(this.nodes);
  StoryNode? operator[](String id) => nodes[id];

  Map<String, dynamic> toJson() => {'nodes': nodes.values.map((n) => n.toJson()).toList()};
  static StoryGraph fromJson(Map<String, dynamic> m) {
    final list = (m['nodes'] as List).map((e) => StoryNode.fromJson(Map<String, dynamic>.from(e))).toList();
    return StoryGraph({for (final n in list) n.id: n});
  }
}
