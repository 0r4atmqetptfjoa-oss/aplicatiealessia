import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimeTrackingService {
  static const _kDayKey = 'tt_day';
  static const _kMinutesKey = 'tt_minutes';
  final ValueNotifier<int> minutesToday = ValueNotifier(0);
  final ValueNotifier<int> breakTick = ValueNotifier(0); // notificare break
  Timer? _timer;
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final dayStr = '${today.year}-${today.month}-${today.day}';
    final storedDay = _prefs!.getString(_kDayKey);
    if (storedDay != dayStr) {
      await _prefs!.setString(_kDayKey, dayStr);
      await _prefs!.setInt(_kMinutesKey, 0);
      minutesToday.value = 0;
    } else {
      minutesToday.value = _prefs!.getInt(_kMinutesKey) ?? 0;
    }
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) async {
      minutesToday.value += 1;
      await _prefs!.setInt(_kMinutesKey, minutesToday.value);
      if (minutesToday.value % 15 == 0) {
        breakTick.value++; // semnal pentru „ia o pauză”
      }
    });
  }

  void dispose() {
    _timer?.cancel();
  }
}
