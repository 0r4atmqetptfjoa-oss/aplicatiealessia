import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Season { auto, spring, summer, autumn, winter, halloween, holidays }

class ThemeService {
  final ValueNotifier<ThemeData> theme = ValueNotifier(_themeForSeason(_detectSeason()));

  Season _override = Season.auto;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString('season_override') ?? 'auto';
    _override = Season.values.firstWhere((e) => e.name == s, orElse: () => Season.auto);
    refresh();
  }

  Future<void> setSeasonOverride(Season s) async {
    _override = s;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('season_override', s.name);
    refresh();
  }

  Season get season => _override;

  void refresh() {
    final used = _override == Season.auto ? _detectSeason() : _override;
    theme.value = _themeForSeason(used);
  }

  static Season _detectSeason() {
    final now = DateTime.now();
    final m = now.month;
    final d = now.day;
    if (m == 10 && d >= 20) return Season.halloween;
    if ((m == 12) || (m == 1 && d <= 7)) return Season.holidays;
    if (m >= 3 && m <= 5) return Season.spring;
    if (m >= 6 && m <= 8) return Season.summer;
    if (m >= 9 && m <= 11) return Season.autumn;
    return Season.winter;
  }

  static ThemeData _themeForSeason(Season s) {
    switch (s) {
      case Season.spring:
        return ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
          brightness: Brightness.light,
          useMaterial3: true,
        );
      case Season.summer:
        return ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
          brightness: Brightness.light,
          useMaterial3: true,
        );
      case Season.autumn:
        return ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          brightness: Brightness.light,
          useMaterial3: true,
        );
      case Season.winter:
        return ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
          brightness: Brightness.light,
          useMaterial3: true,
        );
      case Season.halloween:
        return ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          brightness: Brightness.dark,
          useMaterial3: true,
        );
      case Season.holidays:
        return ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
          brightness: Brightness.light,
          useMaterial3: true,
        );
      case Season.auto:
      default:
        return ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          brightness: Brightness.light,
          useMaterial3: true,
        );
    }
  }
}
