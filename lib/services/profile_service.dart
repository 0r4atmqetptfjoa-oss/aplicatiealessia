import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChildProfile {
  final String id;
  final String name;
  final int color;
  ChildProfile({required this.id, required this.name, required this.color});

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'color': color};
  static ChildProfile fromJson(Map<String, dynamic> j) => ChildProfile(id: j['id'], name: j['name'], color: j['color']);
}

class ProfileService {
  static const _kProfiles = 'profiles';
  static const _kActive = 'active_profile';
  final List<ChildProfile> _profiles = [];
  final ValueNotifier<ChildProfile?> active = ValueNotifier(null);
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs!.getString(_kProfiles);
    if (raw != null) {
      final list = (json.decode(raw) as List).cast<Map>().map((m) => ChildProfile.fromJson(Map<String, dynamic>.from(m))).toList();
      _profiles.clear();
      _profiles.addAll(list);
    }
    if (_profiles.isEmpty) {
      final def = ChildProfile(id: 'p1', name: 'Copil 1', color: 0xFF7E57C2);
      _profiles.add(def);
      await _persist();
    }
    final aid = _prefs!.getString(_kActive) ?? _profiles.first.id;
    active.value = _profiles.firstWhere((p) => p.id == aid, orElse: () => _profiles.first);
  }

  List<ChildProfile> get profiles => List.unmodifiable(_profiles);

  Future<void> setActive(String id) async {
    final p = _profiles.firstWhere((e) => e.id == id);
    active.value = p;
    await _prefs?.setString(_kActive, id);
  }

  Future<void> addProfile(String name, int color) async {
    final id = 'p${DateTime.now().millisecondsSinceEpoch}';
    _profiles.add(ChildProfile(id: id, name: name, color: color));
    await _persist();
  }

  Future<void> renameProfile(String id, String name) async {
    final idx = _profiles.indexWhere((e) => e.id == id);
    if (idx >= 0) {
      _profiles[idx] = ChildProfile(id: _profiles[idx].id, name: name, color: _profiles[idx].color);
      await _persist();
    }
  }

  Future<void> _persist() async {
    final raw = json.encode(_profiles.map((e) => e.toJson()).toList());
    await _prefs?.setString(_kProfiles, raw);
  }
}
