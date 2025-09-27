import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParentalControlService {
  static const _kKey = 'parental_settings';
  bool disableParticles = false;
  bool bgMusicEnabled = true;
  int dailyMinutes = 0; // 0 = nelimitat
  String? pinHash;
  SharedPreferences? _prefs;

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final raw = _prefs!.getString(_kKey);
      if (raw != null) {
        final m = json.decode(raw) as Map<String, dynamic>;
        disableParticles = m['disableParticles'] ?? false;
        bgMusicEnabled = m['bgMusicEnabled'] ?? true;
        dailyMinutes = m['dailyMinutes'] ?? 0;
        pinHash = m['pinHash'];
      }
    } catch (e) {
      if (kDebugMode) print('ParentalControlService init: $e');
    }
  }

  Future<void> save() async {
    try {
      await _prefs?.setString(_kKey, json.encode({
        'disableParticles': disableParticles,
        'bgMusicEnabled': bgMusicEnabled,
        'dailyMinutes': dailyMinutes,
        'pinHash': pinHash,
      }));
    } catch (_) {}
  }

  void setPin(String? pin) {
    if (pin == null || pin.isEmpty) { pinHash = null; }
    else { pinHash = _hash(pin); }
    save();
  }

  bool validatePin(String pin) => pinHash != null && pinHash == _hash(pin);

  String _hash(String s) {
    int h = 0;
    for (final c in s.codeUnits) { h = (h ^ c) & 0xFFFFFFFF; }
    return h.toRadixString(16);
  }
}
