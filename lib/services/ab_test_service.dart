import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ABTestService {
  static const _kKey = 'ab_variants';
  final Map<String, String> _variants = {}; // experiment -> variant(A/B)
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final map = _prefs!.getStringList(_kKey) ?? [];
    for (final pair in map) {
      final sp = pair.split('=');
      if (sp.length == 2) _variants[sp[0]] = sp[1];
    }
  }

  Future<void> setVariant(String experiment, String variant) async {
    _variants[experiment] = variant;
    await _prefs?.setStringList(_kKey, _variants.entries.map((e) => '${e.key}=${e.value}').toList());
  }

  /// Determinist, pe baza unui id (ex: profil activ)
  String assignDeterministic(String experiment, String subjectId) {
    final h = subjectId.codeUnits.fold<int>(0, (a, b) => (a * 31 + b) & 0x7fffffff);
    final v = (h % 2 == 0) ? 'A' : 'B';
    _variants.putIfAbsent(experiment, () => v);
    return v;
  }

  String variantOf(String experiment, {String fallback = 'A'}) => _variants[experiment] ?? fallback;

  // Parametri folosiți în jocuri: cât de mult "apasă" pad-ul
  double get pressScale => variantOf('press_scale') == 'B' ? 0.86 : 0.92;
}
