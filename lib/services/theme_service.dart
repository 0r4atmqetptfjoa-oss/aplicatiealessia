
import 'package:flutter/foundation.dart';

enum ThemeFlavor { classic, forest, underwater, winter }

class ThemeService {
  final ValueNotifier<ThemeFlavor> flavor = ValueNotifier<ThemeFlavor>(ThemeFlavor.classic);
  void setFlavor(ThemeFlavor v) => flavor.value = v;
}
