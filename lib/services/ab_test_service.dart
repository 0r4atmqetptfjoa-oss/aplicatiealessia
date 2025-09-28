import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple & persistent A/B testing allocator.
class ABTestService {
  ABTestService(this._prefs);
  final SharedPreferences _prefs;

  /// Hardcoded experiment configuration (can be fetched from remote config in future).
  final Map<String, List<String>> _config = {
    'homepage_button_color': ['A', 'B'],
    'game_difficulty': ['A', 'B'],
    'StickyCoachHints': ['off', 'on'],
  };

  Future<void> init() async {
    // No-op for now; kept for parity with spec (could warm cache or fetch remote settings).
  }

  /// Returns the variant for the given [experimentName].
  /// Persists the assignment in SharedPreferences.
  String getVariant(String experimentName) {
    final variants = _config[experimentName];
    if (variants == null || variants.isEmpty) {
      // Unknown experiment -> return safe default.
      return 'control';
    }
    final key = 'ab_test_variant_$experimentName';
    final saved = _prefs.getString(key);
    if (saved != null && variants.contains(saved)) return saved;

    // Random assignment with equal probability.
    final rng = Random();
    final choice = variants[rng.nextInt(variants.length)];
    _prefs.setString(key, choice);
    return choice;
  }
}
