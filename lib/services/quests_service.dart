import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Quest {
  final String id;
  final String title;
  final String instrument; // ex: 'piano'
  final int target;
  int progress;
  bool completed;

  Quest({required this.id, required this.title, required this.instrument, required this.target, this.progress = 0, this.completed = false});

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'instrument': instrument, 'target': target, 'progress': progress, 'completed': completed};
  static Quest fromJson(Map<String, dynamic> j) => Quest(id: j['id'], title: j['title'], instrument: j['instrument'], target: j['target'], progress: j['progress'], completed: j['completed']);
}

class QuestsService {
  static const _kKey = 'quests_json';
  final List<Quest> _quests = [];
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs!.getString(_kKey);
    if (raw != null) {
      final list = (json.decode(raw) as List).cast<Map>().map((m) => Quest.fromJson(Map<String, dynamic>.from(m))).toList();
      _quests
        ..clear()
        ..addAll(list);
    }
    if (_quests.isEmpty) {
      _quests.addAll([
        Quest(id: 'q_piano_1', title: 'Pian: Obține 3 succese la rând', instrument: 'piano', target: 3),
        Quest(id: 'q_drums_1', title: 'Tobe: 5 succese totale', instrument: 'drums', target: 5),
        Quest(id: 'q_xylo_1', title: 'Xilofon: 4 succese', instrument: 'xylophone', target: 4),
        Quest(id: 'q_organ_1', title: 'Orgă: 3 succese', instrument: 'organ', target: 3),
      ]);
      await _persist();
    }
  }

  List<Quest> get quests => List.unmodifiable(_quests);

  List<Quest> questsFor(String instrument) => _quests.where((q) => q.instrument == instrument).toList();

  Future<void> recordSuccess(String instrument, int streak) async {
    for (final q in _quests.where((q) => q.instrument == instrument && !q.completed)) {
      // dacă e quest pe "la rând", folosim streak; altfel total
      if (q.title.contains('la rând')) {
        if (streak > q.progress) q.progress = streak;
      } else {
        q.progress = (q.progress + 1).clamp(0, q.target);
      }
      if (q.progress >= q.target) q.completed = true;
    }
    await _persist();
  }

  Future<void> _persist() async {
    await _prefs?.setString(_kKey, json.encode(_quests.map((e) => e.toJson()).toList()));
  }
}
