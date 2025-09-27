import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// Serviciu audio bazat pe SoLoud (flutter_soloud).
/// Conceput să fie *rezistent* la lipsa resurselor (fallback silențios).
class AudioService {
  final SoLoud _soloud = SoLoud.instance;
  AudioSource? _tapSource;
  SoundHandle? _bgmHandle;

  Future<void> init() async {
    try {
      if (!_soloud.isInitialized) {
        await _soloud.init(automaticCleanup: true);
      }
      // Preîncărcare sunet universal "tap".
      // TODO (Răzvan): Înlocuiește cu un efect real, ex: 'assets/audio/final/tap_soft.mp3'
      _tapSource = await _soloud.loadAsset('assets/audio/placeholders/placeholder_sound.mp3');
    } on SoLoudException catch (e, _) {
      debugPrint('SoLoud failed to init: $e');
    } catch (e, _) {
      debugPrint('AudioService init error: $e');
    }
  }

  Future<void> playTap({double volume = 0.9}) async {
    if (_tapSource == null) return;
    try {
      await _soloud.play(_tapSource!, volume: volume);
    } catch (e) {
      debugPrint('playTap error: $e');
    }
  }

  Future<void> playBgmAsset(String assetPath, {double volume = 0.5, bool looping = true}) async {
    try {
      // TODO (Răzvan): Înlocuiește cu un BGM real în /final
      final src = await _soloud.loadAsset(assetPath);
      _bgmHandle = await _soloud.play(src, volume: volume, looping: looping);
    } catch (e) {
      debugPrint('playBgmAsset error: $e');
    }
  }

  void stopBgm() {
    final h = _bgmHandle;
    if (h == null) return;
    _soloud.stop(h);
    _bgmHandle = null;
  }

  Future<void> dispose() async {
    try {
      stopBgm();
      await _soloud.disposeAllSources();
      _soloud.deinit();
    } catch (_) {}
  }
}
