import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParentalService {
  static const _kPin = 'parent_pin'; // stored as 'salt:sha256(pin+salt)'
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get hasPin => _prefs?.getString(_kPin) != null;

  Future<void> setPin(String pin) async {
    final salt = _randString(8);
    final hash = sha256.convert(utf8.encode(pin + salt)).toString();
    await _prefs?.setString(_kPin, '$salt:$hash');
  }

  Future<bool> verifyPin(String pin) async {
    final v = _prefs?.getString(_kPin);
    if (v == null) return false;
    final parts = v.split(':');
    if (parts.length != 2) return false;
    final salt = parts[0];
    final stored = parts[1];
    final hash = sha256.convert(utf8.encode(pin + salt)).toString();
    return stored == hash;
  }

  String _randString(int len) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rnd = Random();
    return List.generate(len, (_) => chars[rnd.nextInt(chars.length)]).join();
  }
}

class AnalyticsService {
  static const _kCounters = 'analytics_counters';
  Map<String, int> _counters = {};
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final mapJson = _prefs!.getString(_kCounters);
    if (mapJson != null) {
      _counters = Map<String, dynamic>.from(json.decode(mapJson)).map((k,v)=>MapEntry(k, (v as num).toInt()));
    }
  }

  Map<String,int> get counters => Map.unmodifiable(_counters);

  Future<void> inc(String key, [int by = 1]) async {
    _counters[key] = (_counters[key] ?? 0) + by;
    await _persist();
  }

  Future<void> reset() async {
    _counters.clear();
    await _persist();
  }

  Future<void> _persist() async {
    await _prefs?.setString(_kCounters, json.encode(_counters));
  }
}
