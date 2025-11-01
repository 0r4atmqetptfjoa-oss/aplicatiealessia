import 'dart:ui';

import 'package:flutter/material.dart';

class UserProfile {
  final String id;
  String name;
  Color themeColor;
  Set<String> unlockedStickers;
  int experiencePoints;

  UserProfile({
    required this.id,
    required this.name,
    required this.themeColor,
    this.unlockedStickers = const {},
    this.experiencePoints = 0,
  });

  // Methods for serialization to/from JSON for local storage
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      themeColor: Color(json['themeColor'] as int),
      unlockedStickers: Set<String>.from(json['unlockedStickers'] ?? []),
      experiencePoints: json['experiencePoints'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'themeColor': themeColor.value,
        'unlockedStickers': unlockedStickers.toList(),
        'experiencePoints': experiencePoints,
      };
}
