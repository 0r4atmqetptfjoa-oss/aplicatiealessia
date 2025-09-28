import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeFlavor {
  classic,
  forest,
  underwater,
  winter,
}

class ThemeService {
  late SharedPreferences _prefs;
  final ValueNotifier<ThemeFlavor> flavor = ValueNotifier(ThemeFlavor.classic);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final flavorName = _prefs.getString('themeFlavor') ?? 'classic';
    flavor.value = ThemeFlavor.values.firstWhere((e) => e.name == flavorName, orElse: () => ThemeFlavor.classic);
  }

  Future<void> setFlavor(ThemeFlavor newFlavor) async {
    flavor.value = newFlavor;
    await _prefs.setString('themeFlavor', newFlavor.name);
  }
}