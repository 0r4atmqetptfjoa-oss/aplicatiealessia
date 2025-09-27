import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticEvent {
  final String type;
  final Map<String, dynamic> data;
  final int ts;
  AnalyticEvent({required this.type, required this.data, required this.ts});

  Map<String, dynamic> toJson() => {'type': type, 'data': data, 'ts': ts};
  static AnalyticEvent fromJson(Map<String, dynamic> m) =>
      AnalyticEvent(type: m['type'], data: Map<String, dynamic>.from(m['data']), ts: m['ts']);
}

class AnalyticsService {
  static const _kEvents = 'analytics_events';
  final List<AnalyticEvent> _events = [];
  SharedPreferences? _prefs;

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final raw = _prefs!.getString(_kEvents);
      if (raw != null) {
        final list = (json.decode(raw) as List).cast<Map<String, dynamic>>();
        _events
          ..clear()
          ..addAll(list.map(AnalyticEvent.fromJson));
      }
    } catch (e) {
      if (kDebugMode) print('Analytics init: $e');
    }
  }

  List<AnalyticEvent> get events => List.unmodifiable(_events);

  Future<void> log(String type, Map<String, dynamic> data) async {
    final ev = AnalyticEvent(type: type, data: data, ts: DateTime.now().millisecondsSinceEpoch);
    _events.add(ev);
    if (_events.length > 500) {
      _events.removeRange(0, _events.length - 500);
    }
    try {
      await _prefs?.setString(_kEvents, json.encode(_events.map((e) => e.toJson()).toList()));
    } catch (_) {}
  }

  Map<String, int> successCountsByInstrument() {
    final map = <String, int>{};
    for (final e in _events) {
      if (e.type == 'coach_success') {
        final inst = e.data['instrument']?.toString() ?? 'unknown';
        map[inst] = (map[inst] ?? 0) + 1;
      }
    }
    return map;
  }
}

Map<String, int> successCountsByInstrumentForProfile(String profileId) {
  final map = <String, int>{};
  for (final e in _events) {
    if (e.type == 'coach_success' && e.data['profile'] == profileId) {
      final inst = e.data['instrument']?.toString() ?? 'unknown';
      map[inst] = (map[inst] ?? 0) + 1;
    }
  }
  return map;
}
