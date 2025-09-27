import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestsService {
  static const _kQuests = 'quests';
  final Map<String, int> _progress = {}; // questId -> count
  SharedPreferences? _prefs;

  final Map<String, int> _goals = const {
    'piano_3_success': 3,
    'drums_3_success': 3,
    'xylophone_3_success': 3,
    'organ_3_success': 3,
    'explore_1_success': 1,
  };

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final raw = _prefs!.getString(_kQuests);
      if (raw != null) {
        final m = Map<String, dynamic>.from(json.decode(raw));
        _progress
          ..clear()
          ..addAll(m.map((k, v) => MapEntry(k, (v as num).toInt())));
      }
    } catch (e) {
      if (kDebugMode) print('Quests init: $e');
    }
  }

  Future<void> _save() async {
    try {
      await _prefs?.setString(_kQuests, json.encode(_progress));
    } catch (_) {}
  }

  void recordInstrumentSuccess(String instrument) {
    final id = '${instrument}_3_success';
    _progress[id] = (_progress[id] ?? 0) + 1;
    _progress['explore_1_success'] = (_progress['explore_1_success'] ?? 0) + 1;
    _save();
  }

  int progressOf(String questId) => _progress[questId] ?? 0;
  int goalOf(String questId) => _goals[questId] ?? 0;
  bool isComplete(String questId) => progressOf(questId) >= goalOf(questId);

  Map<String, int> get allProgress => Map.unmodifiable(_progress);
  Map<String, int> get goals => Map.unmodifiable(_goals);
}
