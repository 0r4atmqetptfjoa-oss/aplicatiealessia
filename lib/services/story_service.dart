
import 'dart:convert';

class StoryChoice {
  final String text;
  final String target; // node id
  StoryChoice(this.text, this.target);
}

class StoryService {
  Map<String, dynamic> _graph = {'nodes': [], 'edges': []};

  String get graphJson => json.encode(_graph);

  Future<void> setGraphFromJson(String jsonStr) async {
    final data = json.decode(jsonStr);
    if (data is Map<String, dynamic>) {
      _graph = data;
    }
  }

  Future<void> addChoice(int fromId, StoryChoice choice) async {
    _graph['edges'] ??= [];
    (_graph['edges'] as List).add({'from': fromId, 'text': choice.text, 'to': choice.target});
  }
}
