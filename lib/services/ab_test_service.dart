import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ABTestService {
  static const _kAssign = 'ab_assign';
  static const _kMetrics = 'ab_metrics';
  Map<String, String> _assign = {};              // key -> 'A' | 'B'
  Map<String, Map<String, int>> _metrics = {};   // key -> {'A':x, 'B':y}
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final a = _prefs!.getString(_kAssign);
    final m = _prefs!.getString(_kMetrics);
    if (a != null) _assign = Map<String, String>.from(json.decode(a));
    if (m != null) {
      final mm = Map<String, dynamic>.from(json.decode(m));
      _metrics = mm.map((k, v) => MapEntry(k, Map<String, int>.from((v as Map).map((kk, vv) => MapEntry(kk.toString(), (vv as num).toInt())))));
    }
  }

  String getVariant(String key) {
    final cur = _assign[key];
    if (cur != null) return cur;
    final v = (DateTime.now().microsecondsSinceEpoch % 2 == 0) ? 'A' : 'B';
    _assign[key] = v;
    _save();
    return v;
  }

  void setVariant(String key, String v) {
    _assign[key] = (v == 'B') ? 'B' : 'A';
    _save();
  }

  void logOutcome(String key, bool success) {
    final v = getVariant(key);
    final map = _metrics[key] ??= {'A': 0, 'B': 0};
    if (success) map[v] = (map[v] ?? 0) + 1;
    _save();
  }

  Map<String, String> get assignments => Map.unmodifiable(_assign);
  Map<String, Map<String, int>> get metrics => { for (final e in _metrics.entries) e.key : Map.unmodifiable(e.value) };

  void _save() {
    _prefs?.setString(_kAssign, json.encode(_assign));
    _prefs?.setString(_kMetrics, json.encode(_metrics));
  }
}


Future<void> reset() async {
  _assignments.clear();
  await _persist();
}
