import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Season { standard, spring, summer, autumn, winter }

class ThemeService {
  static const _kSeasonKey = 'theme_season';
  final ValueNotifier<ThemeData> theme = ValueNotifier(_buildTheme(Season.standard));
  Season _season = Season.standard;
  SharedPreferences? _prefs;

  Season get season => _season;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final idx = _prefs?.getInt(_kSeasonKey) ?? 0;
    _season = Season.values[idx.clamp(0, Season.values.length-1)];
    theme.value = _buildTheme(_season);
  }

  Future<void> setSeason(Season s) async {
    _season = s;
    theme.value = _buildTheme(s);
    await _prefs?.setInt(_kSeasonKey, s.index);
  }

  static ThemeData _buildTheme(Season s) {
    Color seed;
    switch (s) {
      case Season.spring: seed = const Color(0xFF66BB6A); break;   // green
      case Season.summer: seed = const Color(0xFFFFB300); break;   // amber
      case Season.autumn: seed = const Color(0xFF8D6E63); break;   // brown
      case Season.winter: seed = const Color(0xFF42A5F5); break;   // blue
      case Season.standard:
      default: seed = const Color(0xFF7E57C2); break;              // deepPurple-ish
    }
    final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light);
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
      ),
      scaffoldBackgroundColor: scheme.surface,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
    );
  }
}
