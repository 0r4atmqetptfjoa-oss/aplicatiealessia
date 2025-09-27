import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsService {
  static const _kKey = 'analytics_json';
  final Map<String, int> _counters = {};
  final Map<String, int> _timers = {}; // name -> ms cumulati
  final Map<String, int> _starts = {}; // name -> ms start

  Future<void> init() async {
    try {
      final p = await SharedPreferences.getInstance();
      final raw = p.getString(_kKey);
      if (raw != null) {
        final map = Map<String, dynamic>.from(json.decode(raw));
        final c = Map<String, dynamic>.from(map['counters'] ?? {});
        final t = Map<String, dynamic>.from(map['timers'] ?? {});
        _counters.addAll(c.map((k, v) => MapEntry(k, (v as num).toInt())));
        _timers.addAll(t.map((k, v) => MapEntry(k, (v as num).toInt())));
      }
    } catch (e) {
      if (kDebugMode) print('Analytics init err: $e');
    }
  }

  void incr(String key, [int by = 1]) {
    _counters[key] = (_counters[key] ?? 0) + by;
    _persist();
  }

  void startTimer(String key) {
    _starts[key] = DateTime.now().millisecondsSinceEpoch;
  }

  void stopTimer(String key) {
    final st = _starts.remove(key);
    if (st != null) {
      final delta = DateTime.now().millisecondsSinceEpoch - st;
      _timers[key] = (_timers[key] ?? 0) + delta;
      _persist();
    }
  }

  Map<String, int> get counters => Map.unmodifiable(_counters);
  Map<String, int> get timers => Map.unmodifiable(_timers);

  Future<void> _persist() async {
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString(_kKey, json.encode({'counters': _counters, 'timers': _timers}));
    } catch (_) {}
  }
}
