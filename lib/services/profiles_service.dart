import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChildProfile {
  final String id;
  final String name;
  final int color; // ARGB
  ChildProfile({required this.id, required this.name, required this.color});

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'color': color};
  factory ChildProfile.fromJson(Map<String, dynamic> j) => ChildProfile(id: j['id'], name: j['name'], color: j['color']);
}

class ProfilesService {
  static const _kProfiles = 'profiles';
  static const _kActive = 'active_profile';
  final ValueNotifier<List<ChildProfile>> profiles = ValueNotifier(const []);
  final ValueNotifier<ChildProfile?> active = ValueNotifier(null);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kProfiles);
    if (raw != null) {
      final list = (json.decode(raw) as List).cast<Map<String, dynamic>>().map(ChildProfile.fromJson).toList();
      profiles.value = list;
    }
    if (profiles.value.isEmpty) {
      // create default
      final p = ChildProfile(id: 'p1', name: 'Alesia', color: 0xFF7C4DFF);
      profiles.value = [p];
      await _persist();
    }
    final activeId = prefs.getString(_kActive);
    active.value = profiles.value.firstWhere((p) => p.id == activeId, orElse: () => profiles.value.first);
    await _persistActive();
  }

  Future<void> addProfile(ChildProfile p) async {
    profiles.value = [...profiles.value, p];
    await _persist();
  }

  Future<void> deleteProfile(String id) async {
    profiles.value = profiles.value.where((e) => e.id != id).toList();
    if (active.value?.id == id) {
      active.value = profiles.value.isNotEmpty ? profiles.value.first : null;
      await _persistActive();
    }
    await _persist();
  }

  Future<void> setActive(String id) async {
    final found = profiles.value.firstWhere((p) => p.id == id, orElse: () => profiles.value.first);
    active.value = found;
    await _persistActive();
  }

  Future<void> rename(String id, String newName) async {
    profiles.value = profiles.value.map((p) => p.id == id ? ChildProfile(id: p.id, name: newName, color: p.color) : p).toList();
    await _persist();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kProfiles, json.encode(profiles.value.map((e) => e.toJson()).toList()));
  }

  Future<void> _persistActive() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kActive, active.value?.id ?? '');
  }
}
