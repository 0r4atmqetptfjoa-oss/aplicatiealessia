import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChildProfile {
  final String id;
  final String name;
  final String avatar; // ex: 'avatar_1'
  ChildProfile({required this.id, required this.name, required this.avatar});

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'avatar': avatar};
  factory ChildProfile.fromJson(Map<String, dynamic> j) =>
      ChildProfile(id: j['id'], name: j['name'], avatar: j['avatar']);
}

class ProfileService {
  static const _kProfiles = 'profiles';
  static const _kCurrent = 'current_profile';
  final ValueNotifier<ChildProfile?> current = ValueNotifier(null);
  final List<ChildProfile> profiles = [];
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final listJson = _prefs!.getStringList(_kProfiles) ?? [];
    profiles
      ..clear()
      ..addAll(listJson.map((s) => ChildProfile.fromJson(json.decode(s))));
    final id = _prefs!.getString(_kCurrent);
    if (id != null) {
      current.value = profiles.where((p) => p.id == id).cast<ChildProfile?>().firstOrNull;
    }
  }

  Future<void> _persist() async {
    await _prefs?.setStringList(_kProfiles, profiles.map((p) => json.encode(p.toJson())).toList());
    await _prefs?.setString(_kCurrent, current.value?.id ?? '');
  }

  Future<void> createAndSelect(String name, String avatar) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final p = ChildProfile(id: id, name: name, avatar: avatar);
    profiles.add(p);
    current.value = p;
    await _persist();
  }

  Future<void> select(String id) async {
    current.value = profiles.firstWhere((p) => p.id == id);
    await _persist();
  }

  Future<void> delete(String id) async {
    profiles.removeWhere((p) => p.id == id);
    if (current.value?.id == id) {
      current.value = profiles.isNotEmpty ? profiles.first : null;
    }
    await _persist();
  }

  bool get hasCurrent => current.value != null;
}

extension FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
