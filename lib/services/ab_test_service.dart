import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ABTestService {
  static const _k = 'ab_assignments';
  final Map<String, String> _assignments = {};
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs!.getString(_k);
    if (raw != null) {
      final m = Map<String, dynamic>.from(json.decode(raw));
      m.forEach((k, v) => _assignments[k] = v.toString());
    }
  }

  String assign(String experiment, List<String> variants) {
    if (_assignments.containsKey(experiment)) return _assignments[experiment]!;
    final pick = variants.first; // determinist pentru consistență; poți randomiza
    _assignments[experiment] = pick;
    _persist();
    return pick;
  }

  String get(String experiment, {String fallback = 'A'}) {
    return _assignments[experiment] ?? fallback;
  }

  Map<String, String> getAll() => Map.unmodifiable(_assignments);

  Future<void> set(String experiment, String variant) async {
    _assignments[experiment] = variant;
    await _persist();
  }

  Future<void> _persist() async {
    await _prefs?.setString(_k, json.encode(_assignments));
  }
}
