import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticEvent {
  final String type;
  final Map<String, dynamic> data;
  final int ts;
  AnalyticEvent(this.type, this.data) : ts = DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toJson() => {'type': type, 'data': data, 'ts': ts};
  static AnalyticEvent fromJson(Map<String, dynamic> j) => AnalyticEvent(j['type'], Map<String, dynamic>.from(j['data']));
}

class AnalyticsService {
  static const _kKey = 'analytics_events';
  final List<AnalyticEvent> _buffer = [];
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs?.getString(_kKey);
    if (raw != null) {
      final list = (json.decode(raw) as List).cast<Map<String, dynamic>>();
      _buffer
        ..clear()
        ..addAll(list.map(AnalyticEvent.fromJson));
    }
  }

  List<AnalyticEvent> get events => List.unmodifiable(_buffer.reversed);

  Future<void> log(String type, Map<String, dynamic> data) async {
    _buffer.add(AnalyticEvent(type, data));
    if (_buffer.length > 300) {
      _buffer.removeAt(0);
    }
    await _persist();
  }

  Future<void> clear() async {
    _buffer.clear();
    await _persist();
  }

  Future<void> _persist() async {
    await _prefs?.setString(_kKey, json.encode(_buffer.map((e)=>e.toJson()).toList()));
  }
}
