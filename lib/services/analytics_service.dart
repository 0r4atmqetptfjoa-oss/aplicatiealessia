import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsService {
  static const _kKey = 'analytics_v1';
  int _sessionStart = 0;
  int totalMillis = 0;
  final Map<String, int> instrumentCounts = {}; // ex: {'piano': 12, 'drums': 5}
  final ValueNotifier<int> totalSessions = ValueNotifier(0);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kKey);
    if (raw != null) {
      final map = json.decode(raw) as Map<String, dynamic>;
      totalMillis = (map['totalMillis'] ?? 0) as int;
      final ic = Map<String, dynamic>.from(map['instrumentCounts'] ?? {});
      instrumentCounts.clear();
      ic.forEach((k, v) => instrumentCounts[k] = (v as num).toInt());
      totalSessions.value = (map['totalSessions'] ?? 0) as int;
    }
  }

  void startSession() {
    _sessionStart = DateTime.now().millisecondsSinceEpoch;
    totalSessions.value += 1;
    _save();
  }

  Future<void> endSession() async {
    if (_sessionStart == 0) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    totalMillis += (now - _sessionStart);
    _sessionStart = 0;
    await _save();
  }

  Future<void> logInstrumentTap(String instrument) async {
    instrumentCounts[instrument] = (instrumentCounts[instrument] ?? 0) + 1;
    await _save();
  }

  Future<void> resetAll() async {
    _sessionStart = 0;
    totalMillis = 0;
    instrumentCounts.clear();
    totalSessions.value = 0;
    await _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kKey, json.encode({
      'totalMillis': totalMillis,
      'instrumentCounts': instrumentCounts,
      'totalSessions': totalSessions.value,
    }));
  }
}
