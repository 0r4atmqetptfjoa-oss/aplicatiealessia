import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppTheme { light, dark, jungle }

class ThemeService extends ChangeNotifier {
  ThemeService(this._prefs);
  final SharedPreferences _prefs;

  static const _key = 'app_theme_v1';
  late AppTheme _currentTheme;

  final Map<AppTheme, ThemeData> _themes = {
    AppTheme.light: ThemeData(
      colorSchemeSeed: Colors.deepPurple,
      brightness: Brightness.light,
      useMaterial3: true,
    ),
    AppTheme.dark: ThemeData(
      colorSchemeSeed: Colors.deepPurple,
      brightness: Brightness.dark,
      useMaterial3: true,
    ),
    AppTheme.jungle: ThemeData(
      colorSchemeSeed: const Color(0xFF2E7D32),
      brightness: Brightness.light,
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF1F8E9),
      appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF81C784)),
      cardTheme: const CardTheme(surfaceTintColor: Color(0xFFA5D6A7)),
    ),
  };

  Future<void> init() async {
    final saved = _prefs.getString(_key);
    _currentTheme = _stringToTheme(saved) ?? AppTheme.light;
    notifyListeners();
  }

  ThemeData get currentThemeData => _themes[_currentTheme]!;
  AppTheme get current => _currentTheme;

  Future<void> setTheme(AppTheme theme) async {
    if (_currentTheme == theme) return;
    _currentTheme = theme;
    await _prefs.setString(_key, _themeToString(theme));
    notifyListeners();
  }

  String _themeToString(AppTheme t) {
    switch (t) {
      case AppTheme.light: return 'light';
      case AppTheme.dark: return 'dark';
      case AppTheme.jungle: return 'jungle';
    }
  }

  AppTheme? _stringToTheme(String? s) {
    switch (s) {
      case 'light': return AppTheme.light;
      case 'dark': return AppTheme.dark;
      case 'jungle': return AppTheme.jungle;
      default: return null;
    }
  }
}
