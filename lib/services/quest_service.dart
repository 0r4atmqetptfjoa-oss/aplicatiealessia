import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Quest {
  final String id;
  final String title;
  final String description;
  final int goal;
  int progress;
  bool claimed;
  final String rewardSticker; // ex: 'piano-crown'

  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.goal,
    required this.progress,
    required this.claimed,
    required this.rewardSticker,
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'title': title, 'description': description,
    'goal': goal, 'progress': progress, 'claimed': claimed,
    'rewardSticker': rewardSticker
  };

  factory Quest.fromJson(Map<String,dynamic> j) => Quest(
    id: j['id'], title: j['title'], description: j['description'],
    goal: j['goal'], progress: j['progress'], claimed: j['claimed'],
    rewardSticker: j['rewardSticker'],
  );
}

class QuestService {
  static const _kQuests = 'quests';
  late List<Quest> _quests;
  SharedPreferences? _prefs;

  List<Quest> get quests => List.unmodifiable(_quests);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final saved = _prefs!.getStringList(_kQuests);
    if (saved != null) {
      _quests = saved.map((s)=>Quest.fromJson(Map<String,dynamic>.from(json.decode(s)))).toList();
    } else {
      _quests = [
        Quest(id: 'first_win', title: 'Prima victorie', description: 'Reușește o secvență de ritm.', goal: 1, progress: 0, claimed: false, rewardSticker: 'star'),
        Quest(id: 'triple_play', title: '3 victorii', description: 'Reușește 3 secvențe de ritm.', goal: 3, progress: 0, claimed: false, rewardSticker: 'crown'),
        Quest(id: 'taps_20', title: '20 atingeri', description: 'Atinge pad-urile de 20 de ori.', goal: 20, progress: 0, claimed: false, rewardSticker: 'note'),
        Quest(id: 'streak_5', title: 'Streak 5', description: 'Obține un streak de 5.', goal: 5, progress: 0, claimed: false, rewardSticker: 'sparkle'),
      ];
      await _persist();
    }
  }

  Future<void> _persist() async {
    await _prefs?.setStringList(_kQuests, _quests.map((q)=>json.encode(q.toJson())).toList());
  }

  Future<void> onCoachSuccess() async {
    _advance('first_win'); _advance('triple_play');
    await _persist();
  }

  Future<void> onTapAny() async {
    _advance('taps_20');
    await _persist();
  }

  Future<void> onBestStreak(int streak) async {
    final q = _quests.firstWhere((q)=>q.id=='streak_5');
    if (q.progress < streak) {
      q.progress = streak.clamp(0, q.goal);
      await _persist();
    }
  }

  void _advance(String id) {
    final q = _quests.firstWhere((q)=>q.id==id);
    if (q.progress < q.goal) q.progress++;
  }

  Future<bool> claim(String id) async {
    final q = _quests.firstWhere((q)=>q.id==id);
    if (!q.claimed && q.progress >= q.goal) {
      q.claimed = true;
      await _persist();
      return true;
    }
    return false;
  }
}
