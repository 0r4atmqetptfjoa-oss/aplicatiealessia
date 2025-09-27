import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChildProfile {
  final String id;
  final String name;
  final int color; // ARGB int
  final String avatarAsset; // path in assets/images/final/...
  ChildProfile({required this.id, required this.name, required this.color, required this.avatarAsset});

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'color': color, 'avatar': avatarAsset};
  static ChildProfile fromJson(Map<String, dynamic> j) => ChildProfile(
    id: j['id'], name: j['name'], color: j['color'], avatarAsset: j['avatar'] ?? 'assets/images/placeholders/placeholder_square.png');
}

class ProfileService {
  static const _kProfilesKey = 'profiles';
  static const _kActiveIdKey = 'active_profile_id';
  final ValueNotifier<ChildProfile?> active = ValueNotifier(null);
  final List<ChildProfile> _profiles = [];
  SharedPreferences? _prefs;

  List<ChildProfile> get profiles => List.unmodifiable(_profiles);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs!.getString(_kProfilesKey);
    if (raw != null) {
      final list = (json.decode(raw) as List).cast<Map<String, dynamic>>();
      _profiles
        ..clear()
        ..addAll(list.map(ChildProfile.fromJson));
    }
    if (_profiles.isEmpty) {
      // Create a default profile
      _profiles.add(ChildProfile(
        id: 'p1',
        name: 'Alesia',
        color: Colors.deepPurple.value,
        // TODO (Răzvan): Înlocuiește cu avatarul final al copilului
        avatarAsset: 'assets/images/placeholders/placeholder_square.png',
      ));
      await _persist();
    }
    final activeId = _prefs!.getString(_kActiveIdKey) ?? _profiles.first.id;
    active.value = _profiles.firstWhere((p) => p.id == activeId, orElse: () => _profiles.first);
  }

  Future<void> setActive(String id) async {
    final p = _profiles.firstWhere((e) => e.id == id);
    active.value = p;
    await _prefs?.setString(_kActiveIdKey, id);
  }

  Future<void> addProfile(ChildProfile p) async {
    _profiles.add(p);
    await _persist();
  }

  Future<void> deleteProfile(String id) async {
    _profiles.removeWhere((e) => e.id == id);
    if (active.value?.id == id && _profiles.isNotEmpty) {
      await setActive(_profiles.first.id);
    }
    await _persist();
  }

  Future<void> updateProfile(ChildProfile updated) async {
    final idx = _profiles.indexWhere((e) => e.id == updated.id);
    if (idx >= 0) _profiles[idx] = updated;
    await _persist();
  }

  Future<void> _persist() async {
    try {
      await _prefs?.setString(_kProfilesKey, json.encode(_profiles.map((e) => e.toJson()).toList()));
    } catch (_) {}
  }
}
