import 'package:flutter/foundation.dart';

/// A simple service managing user settings such as sound and music.
///
/// This class exposes boolean properties for various toggles. It notifies
/// listeners whenever a setting changes so that the UI can update.
class SettingsService extends ChangeNotifier {
  bool _soundOn = true;
  bool _musicOn = true;
  bool _hardMode = false;

  bool get soundOn => _soundOn;
  bool get musicOn => _musicOn;
  bool get hardMode => _hardMode;

  /// Toggle the sound setting.
  void toggleSound(bool value) {
    _soundOn = value;
    notifyListeners();
  }

  /// Toggle the music setting.
  void toggleMusic(bool value) {
    _musicOn = value;
    notifyListeners();
  }

  /// Toggle the difficulty mode. When hard mode is enabled games may
  /// present more challenging questions or levels.
  void toggleHardMode(bool value) {
    _hardMode = value;
    notifyListeners();
  }
}