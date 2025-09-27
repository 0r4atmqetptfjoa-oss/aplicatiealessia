import 'package:flutter/foundation.dart';

/// Simple feedback + scoring channel from Flame games to Flutter UI.
class GameFeedback extends ChangeNotifier {
  String _mood = 'idle';
  int score = 0;
  int combo = 0;

  String get mood => _mood;

  set mood(String value) {
    if (_mood == value) return;
    _mood = value;
    notifyListeners();
  }

  void reset() {
    score = 0;
    combo = 0;
    _mood = 'idle';
    notifyListeners();
  }

  void hitGood() {
    combo += 1;
    score += 10 * combo;
    // escalate mood with combo
    if (combo >= 8) {
      mood = 'dance_fast';
    } else if (combo >= 3) {
      mood = 'dance_slow';
    } else {
      mood = 'idle';
    }
    notifyListeners();
  }

  void miss() {
    combo = 0;
    mood = 'idle';
    notifyListeners();
  }
}
