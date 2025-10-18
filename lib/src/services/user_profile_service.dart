import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class UserProfileService {
  static const _profilesKey = 'user_profiles';
  static const _activeProfileKey = 'active_profile_id';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<List<UserProfile>> getProfiles() async {
    final prefs = await _prefs;
    final profilesJson = prefs.getStringList(_profilesKey) ?? [];
    return profilesJson.map((json) => UserProfile.fromJson(jsonDecode(json))).toList();
  }

  Future<void> saveProfile(UserProfile profile) async {
    final prefs = await _prefs;
    final profiles = await getProfiles();
    final index = profiles.indexWhere((p) => p.id == profile.id);
    if (index != -1) {
      profiles[index] = profile;
    } else {
      profiles.add(profile);
    }
    final profilesJson = profiles.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList(_profilesKey, profilesJson);
  }

  Future<UserProfile> createNewProfile(String name) async {
    final random = Random();
    final colors = [Colors.blue, Colors.green, Colors.red, Colors.orange, Colors.purple];
    final profile = UserProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      themeColor: colors[random.nextInt(colors.length)],
    );
    await saveProfile(profile);
    return profile;
  }

  Future<void> setActiveProfile(String profileId) async {
    final prefs = await _prefs;
    await prefs.setString(_activeProfileKey, profileId);
  }

  Future<String?> getActiveProfileId() async {
    final prefs = await _prefs;
    return prefs.getString(_activeProfileKey);
  }
}

final userProfileServiceProvider = Provider<UserProfileService>((ref) {
  return UserProfileService();
});

final activeProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final service = ref.watch(userProfileServiceProvider);
  final activeId = await service.getActiveProfileId();
  if (activeId == null) return null;

  final profiles = await service.getProfiles();
  return profiles.firstWhere((p) => p.id == activeId, orElse: () => null);
});
