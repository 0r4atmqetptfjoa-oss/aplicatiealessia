import 'package:flutter/material.dart';

enum SeasonTheme { auto, spring, summer, autumn, winter }

class ThemeService {
  final ValueNotifier<ThemeData> theme = ValueNotifier(_build(SeasonTheme.autumn));
  SeasonTheme _current = SeasonTheme.autumn;

  SeasonTheme get current => _current;

  void setTheme(SeasonTheme season) {
    _current = season;
    theme.value = _build(season);
  }

  static ThemeData _build(SeasonTheme s) {
    switch (s) {
      case SeasonTheme.spring:
        return ThemeData(
          colorSchemeSeed: const Color(0xFF66BB6A),
          brightness: Brightness.light,
          useMaterial3: true,
        );
      case SeasonTheme.summer:
        return ThemeData(
          colorSchemeSeed: const Color(0xFFFFB300),
          brightness: Brightness.light,
          useMaterial3: true,
        );
      case SeasonTheme.autumn:
        return ThemeData(
          colorSchemeSeed: const Color(0xFF8D6E63),
          brightness: Brightness.light,
          useMaterial3: true,
        );
      case SeasonTheme.winter:
        return ThemeData(
          colorSchemeSeed: const Color(0xFF90CAF9),
          brightness: Brightness.light,
          useMaterial3: true,
        );
      case SeasonTheme.auto:
      default:
        return ThemeData(
          colorSchemeSeed: const Color(0xFF7E57C2),
          brightness: Brightness.light,
          useMaterial3: true,
        );
    }
  }
}
