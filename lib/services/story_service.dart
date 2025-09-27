import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class StoryChoice { final String text; final String nextId; StoryChoice(this.text, this.nextId); factory StoryChoice.fromJson(Map<String,dynamic> m)=>StoryChoice(m['text'], m['nextId']); Map<String,dynamic> toJson()=>{'text':text,'nextId':nextId}; }
class StoryNode { final String id; final String subtitle; final String? audioId; final List<StoryChoice> choices; StoryNode({required this.id, required this.subtitle, this.audioId, this.choices = const []});
  factory StoryNode.fromJson(Map<String,dynamic> m)=>StoryNode(id:m['id'], subtitle:m['subtitle'], audioId:m['audioId'], choices:(m['choices'] as List? ?? []).map((e)=>StoryChoice.fromJson(Map<String,dynamic>.from(e))).toList());
  Map<String,dynamic> toJson()=>{'id':id,'subtitle':subtitle,'audioId':audioId,'choices':choices.map((e)=>e.toJson()).toList()};
}
class StoryService {
  Map<String, StoryNode> _graph = {};
  Map<String, String> _audioMap = {}; // id -> file path
  Map<String, String> _imageMap = {}; // nodeId -> file path
  Map<String, StoryNode> get graph => _graph;

  Future<void> loadFromAssets([String path='assets/stories/sample_story.json']) async {
    final raw = await rootBundle.loadString(path);
    setFromJsonString(raw);
  }

  void setFromJsonString(String raw) {
    final data = json.decode(raw) as Map<String,dynamic>;
    final nodes = (data['nodes'] as List).cast<Map<String,dynamic>>();
    _graph = { for (final n in nodes.map(StoryNode.fromJson)) n.id : n };
  }

  String toJsonString() {
    final nodes = _graph.values.map((e) => e.toJson()).toList();
    return json.encode({'nodes': nodes});
  }
}

Map<String, String> get audioMap => Map.unmodifiable(_audioMap);
Map<String, String> get imageMap => Map.unmodifiable(_imageMap);

Future<void> setAudioMap(Map<String, String> m) async {
  _audioMap = Map.of(m);
  await _prefs?.setString(_kAudio, json.encode(_audioMap));
}

Future<void> setImageMap(Map<String, String> m) async {
  _imageMap = Map.of(m);
  await _prefs?.setString(_kImage, json.encode(_imageMap));
}

void setAssetMaps(Map<String, String> a, Map<String, String> i) {
  _audioMap = Map.of(a);
  _imageMap = Map.of(i);
  _prefs?.setString(_kAudio, json.encode(_audioMap));
  _prefs?.setString(_kImage, json.encode(_imageMap));
}

String? audioFileForId(String id) => _audioMap[id];
String? imageFileForNode(String nodeId) => _imageMap[nodeId];
