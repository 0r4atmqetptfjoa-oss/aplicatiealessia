import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

class AudioService {
  final SoLoud _soloud = SoLoud.instance;
  AudioSource? _tap;

  bool _ready = false;

  Future<void> init() async {
    try {
      await _soloud.init();
      // TODO (Răzvan): Înlocuiește cu sunetul final, ex: 'assets/audio/final/tap.mp3'
      _tap = await _soloud.loadAsset('assets/audio/placeholders/placeholder_sound.mp3');
      _ready = true;
    } catch (e) {
      _ready = false;
      if (kDebugMode) {
        // In modul placeholder (fără fișier audio real), ignorăm erorile.
        print('AudioService init fallback: $e');
      }
    }
  }

  Future<void> playTap() async {
    if (_ready && _tap != null) {
      try {
        await _soloud.play(_tap!);
      } catch (_) {
        // fallback no-op
      }
    }
  }

  Future<void> dispose() async {
    try {
      await _soloud.deinit();
    } catch (_) {}
  }
}
