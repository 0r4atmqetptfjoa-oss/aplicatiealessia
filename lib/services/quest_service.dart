import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Quest {
  final String id;       // ex: piano_first_success
  final String title;
  final String instrument; // piano, drums, xylophone, organ
  final int target;      // ținta (ex: streak)
  final int progress;    // progres curent (0/1 pentru first_success sau valoare streak maxim).
  final bool completed;

  Quest({required this.id, required this.title, required this.instrument, required this.target, required this.progress, required this.completed});

  Map<String, dynamic> toJson() =>
      {'id': id, 'title': title, 'instrument': instrument, 'target': target, 'progress': progress, 'completed': completed};

  Quest copyWith({int? progress, bool? completed}) =>
      Quest(id: id, title: title, instrument: instrument, target: target, progress: progress ?? this.progress, completed: completed ?? this.completed);

  static Quest fromJson(Map<String, dynamic> j) =>
      Quest(id: j['id'], title: j['title'], instrument: j['instrument'], target: j['target'], progress: j['progress'], completed: j['completed']);
}

class QuestService {
  static const _kKey = 'quests_v1';
  late List<Quest> _quests;
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs?.getString(_kKey);
    if (raw != null) {
      final list = (json.decode(raw) as List).cast<Map<String, dynamic>>();
      _quests = list.map(Quest.fromJson).toList();
    } else {
      _quests = _defaultQuests();
      await _persist();
    }
  }

  List<Quest> get quests => List.unmodifiable(_quests);

  List<Quest> _defaultQuests() {
    final res = <Quest>[];
    for (final ins in ['piano','drums','xylophone','organ']) {
      res.add(Quest(id: '${ins}_first_success', title: 'Prima reușită la ${ins}', instrument: ins, target: 1, progress: 0, completed: false));
      res.add(Quest(id: '${ins}_streak_3', title: 'Obține streak 3 la ${ins}', instrument: ins, target: 3, progress: 0, completed: false));
      res.add(Quest(id: '${ins}_streak_5', title: 'Obține streak 5 la ${ins}', instrument: ins, target: 5, progress: 0, completed: false));
    }
    return res;
    }

  Future<void> onSuccess(String instrument, int streak) async {
    bool changed = false;
    for (var i = 0; i < _quests.length; i++) {
      final q = _quests[i];
      if (q.instrument != instrument || q.completed) continue;
      if (q.id.endsWith('first_success')) {
        _quests[i] = q.copyWith(progress: 1, completed: true); changed = true;
      } else if (q.id.endsWith('streak_3') && streak >= 3) {
        _quests[i] = q.copyWith(progress: 3, completed: true); changed = true;
      } else if (q.id.endsWith('streak_5') && streak >= 5) {
        _quests[i] = q.copyWith(progress: 5, completed: true); changed = true;
      }
    }
    if (changed) await _persist();
  }

  Future<void> _persist() async {
    await _prefs?.setString(_kKey, json.encode(_quests.map((e)=>e.toJson()).toList()));
  }
}
