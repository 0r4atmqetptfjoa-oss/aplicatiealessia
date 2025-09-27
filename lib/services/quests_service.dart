import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Quest {
  final String id;
  final String title;
  final String instrument; // 'piano' | 'drums' | 'xylophone' | 'organ' | '*'
  final int goal;
  final int progress;
  final bool completed;
  const Quest({required this.id, required this.title, required this.instrument, required this.goal, required this.progress, required this.completed});

  Quest copyWith({int? progress, bool? completed}) =>
      Quest(id: id, title: title, instrument: instrument, goal: goal, progress: progress ?? this.progress, completed: completed ?? this.completed);

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'instrument': instrument, 'goal': goal, 'progress': progress, 'completed': completed};
  factory Quest.fromJson(Map<String, dynamic> j) => Quest(
    id: j['id'], title: j['title'], instrument: j['instrument'], goal: j['goal'], progress: j['progress'], completed: j['completed']);
}

class QuestsService {
  static const _kKey = 'quests_v1';
  final ValueNotifier<List<Quest>> quests = ValueNotifier(const []);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kKey);
    if (raw != null) {
      final list = (json.decode(raw) as List).cast<Map<String, dynamic>>().map(Quest.fromJson).toList();
      quests.value = list;
    }
    if (quests.value.isEmpty) {
      quests.value = [
        const Quest(id: 'q1', title: 'Pian: 3 reușite la rând', instrument: 'piano', goal: 3, progress: 0, completed: false),
        const Quest(id: 'q2', title: 'Tobe: 2 reușite la rând', instrument: 'drums', goal: 2, progress: 0, completed: false),
        const Quest(id: 'q3', title: 'Xilofon: 4 reușite', instrument: 'xylophone', goal: 4, progress: 0, completed: false),
        const Quest(id: 'q4', title: 'Orgă: 3 reușite', instrument: 'organ', goal: 3, progress: 0, completed: false),
      ];
      await _save();
    }
  }

  Future<void> onSuccess(String instrument) async {
    final list = quests.value.map((q) {
      if (q.completed) return q;
      if (q.instrument == instrument || q.instrument == '*') {
        final p = q.progress + 1;
        final done = p >= q.goal;
        return q.copyWith(progress: p, completed: done);
      }
      return q;
    }).toList();
    quests.value = list;
    await _save();
  }

  Future<void> resetAll() async {
    quests.value = quests.value.map((q) => q.copyWith(progress: 0, completed: false)).toList();
    await _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kKey, json.encode(quests.value.map((e) => e.toJson()).toList()));
  }
}
