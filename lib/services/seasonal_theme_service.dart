import 'package:flutter/material.dart';

enum SeasonTheme { spring, summer, autumn, winter }

class SeasonalThemeService {
  final ValueNotifier<SeasonTheme> mode = ValueNotifier(SeasonTheme.spring);

  ThemeData get theme => themeFor(mode.value);

  ThemeData themeFor(SeasonTheme s) {
    switch (s) {
      case SeasonTheme.summer:
        return ThemeData(
          brightness: Brightness.light,
          colorSchemeSeed: Colors.orange,
          useMaterial3: true,
        );
      case SeasonTheme.autumn:
        return ThemeData(
          brightness: Brightness.light,
          colorSchemeSeed: Colors.deepOrange,
          useMaterial3: true,
        );
      case SeasonTheme.winter:
        return ThemeData(
          brightness: Brightness.light,
          colorSchemeSeed: Colors.lightBlue,
          useMaterial3: true,
        );
      case SeasonTheme.spring:
      default:
        return ThemeData(
          brightness: Brightness.light,
          colorSchemeSeed: Colors.deepPurple,
          useMaterial3: true,
        );
    }
  }

  void setSeason(SeasonTheme s) => mode.value = s;
}
