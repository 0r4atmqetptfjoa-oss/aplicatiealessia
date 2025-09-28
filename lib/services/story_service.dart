import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

class StoryChoice {
  final String text;
  final String targetNodeId;

  StoryChoice(this.text, this.targetNodeId);

  StoryChoice.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        targetNodeId = json['target'];

  Map<String, dynamic> toJson() => {
    'text': text,
    'target': targetNodeId,
  };
}

class StoryNode {
  final String id;
  final String text;
  final List<StoryChoice> choices;

  StoryNode(this.id, this.text, this.choices);

  StoryNode.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        text = json['text'],
        choices = (json['choices'] as List)
            .map((e) => StoryChoice.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'choices': choices.map((e) => e.toJson()).toList(),
  };
}

class StoryService {
  late SharedPreferences _prefs;
  Map<String, StoryNode> _graph = {};

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final defaultStory = await rootBundle.loadString('assets/stories/default_story.json');
    final storyJson = _prefs.getString('story') ?? defaultStory;
    _loadGraph(storyJson);
  }

  void _loadGraph(String json) {
    final List<dynamic> nodes = jsonDecode(json);
    _graph = {for (var node in nodes) node['id']: StoryNode.fromJson(node)};
  }

  StoryNode? getNode(String id) => _graph[id];

  Future<void> setGraphFromJson(String json) async {
    _loadGraph(json);
    await _prefs.setString('story', json);
  }

  String get graphJson => jsonEncode(_graph.values.map((e) => e.toJson()).toList());
}