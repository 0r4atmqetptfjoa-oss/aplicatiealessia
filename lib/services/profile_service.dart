import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ChildProfile {
  final String id;
  String name;
  int color;

  ChildProfile({required this.id, required this.name, required this.color});

  factory ChildProfile.fromJson(Map<String, dynamic> json) {
    return ChildProfile(
      id: json['id'],
      name: json['name'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
    };
  }
}

class ProfileService {
  late SharedPreferences _prefs;
  final Uuid _uuid = const Uuid();

  final ValueNotifier<List<ChildProfile>> profiles = ValueNotifier([]);
  final ValueNotifier<String?> activeId = ValueNotifier(null);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadProfiles();
  }

  void _loadProfiles() {
    final profilesJson = _prefs.getStringList('profiles') ?? [];
    profiles.value = profilesJson
        .map((json) => ChildProfile.fromJson(jsonDecode(json)))
        .toList();
    activeId.value = _prefs.getString('activeProfile');
    if (activeId.value == null && profiles.value.isNotEmpty) {
      activeId.value = profiles.value.first.id;
    }
  }

  Future<void> _saveProfiles() async {
    final profilesJson =
        profiles.value.map((p) => jsonEncode(p.toJson())).toList();
    await _prefs.setStringList('profiles', profilesJson);
    await _prefs.setString('activeProfile', activeId.value ?? '');
  }

  Future<void> addProfile(String name, int color) async {
    final newProfile = ChildProfile(id: _uuid.v4(), name: name, color: color);
    final updatedProfiles = List<ChildProfile>.from(profiles.value)..add(newProfile);
    profiles.value = updatedProfiles;
    if (activeId.value == null) {
      setActive(newProfile.id);
    }
    await _saveProfiles();
  }

  Future<void> setActive(String id) async {
    activeId.value = id;
    await _saveProfiles();
  }
  
  ChildProfile? get active {
    if (activeId.value == null) {
      return null;
    }
    try {
      return profiles.value.firstWhere((p) => p.id == activeId.value);
    } catch (e) {
      return null;
    }
  }
}