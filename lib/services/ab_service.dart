import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ABService {
  static const _k = 'ab_assignments';
  final Map<String, String> _assign = {};
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs!.getString(_k);
    if (raw != null) {
      final m = Map<String, dynamic>.from(json.decode(raw));
      m.forEach((k, v) => _assign[k] = v.toString());
    } else {
      // default assignment
      _assign['home_bounce'] = 'A'; // A = bounce mic, B = bounce mare
      await _persist();
    }
  }

  String variant(String key) => _assign[key] ?? 'A';
  Future<void> setVariant(String key, String value) async {
    _assign[key] = value;
    await _persist();
  }

  Future<void> _persist() async {
    await _prefs?.setString(_k, json.encode(_assign));
  }
}
