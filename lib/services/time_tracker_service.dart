import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimeTrackerService {
  static const _kTodayMs = 'today_ms';
  static const _kLastDate = 'last_date';
  SharedPreferences? _prefs;
  int _sessionStart = 0;
  final ValueNotifier<Duration> today = ValueNotifier(Duration.zero);
  final ValueNotifier<bool> shouldBreak = ValueNotifier(false);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final lastDate = _prefs!.getString(_kLastDate);
    final todayStr = DateTime.now().toIso8601String().substring(0,10);
    if (lastDate != todayStr) {
      await _prefs!.setInt(_kTodayMs, 0);
      await _prefs!.setString(_kLastDate, todayStr);
    }
    final ms = _prefs!.getInt(_kTodayMs) ?? 0;
    today.value = Duration(milliseconds: ms);
  }

  void onResume() { _sessionStart = DateTime.now().millisecondsSinceEpoch; }
  Future<void> onPauseOrStop({int breakIntervalMinutes = 20, int dailyLimitMinutes = 0}) async {
    if (_sessionStart == 0) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    final delta = now - _sessionStart;
    _sessionStart = 0;
    final cur = (await _prefs!.getInt(_kTodayMs)) ?? 0;
    final total = cur + delta;
    await _prefs!.setInt(_kTodayMs, total);
    today.value = Duration(milliseconds: total);
    final mins = today.value.inMinutes;
    if (breakIntervalMinutes > 0 && mins % breakIntervalMinutes == 0) {
      shouldBreak.value = true;
    }
    if (dailyLimitMinutes > 0 && mins >= dailyLimitMinutes) {
      shouldBreak.value = true;
    }
  }
}
