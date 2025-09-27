import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class TimeTrackerService {
  static const _kKeyPrefix = 'elapsed_'; // ex: elapsed_2025-09-27
  final ValueNotifier<int> elapsedMinutes = ValueNotifier(0);
  Timer? _timer;
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadToday();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => _tickMinute());
  }

  void _loadToday() {
    final k = _todayKey();
    final m = _prefs?.getInt(k) ?? 0;
    elapsedMinutes.value = m;
  }

  String _todayKey() {
    final s = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return '$_kKeyPrefix$s';
  }

  Future<void> _tickMinute() async {
    final k = _todayKey();
    final next = (elapsedMinutes.value + 1);
    elapsedMinutes.value = next;
    await _prefs?.setInt(k, next);
  }

  Future<void> resetToday() async {
    final k = _todayKey();
    await _prefs?.remove(k);
    _loadToday();
  }
}
