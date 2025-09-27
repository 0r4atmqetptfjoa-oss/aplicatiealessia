import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/story_service.dart';

class AudioService {
  final SoLoud _soloud = SoLoud.instance;
  final Map<String, AudioSource> _cache = {};
  AudioSource? _tap;
  bool _ready = false;
  Timer? _ambientTimer;
  String? _ambientId;
  final ValueNotifier<double> musicPosSec = ValueNotifier(0.0);
  final ValueNotifier<double> musicDurSec = ValueNotifier(0.0);
  bool _isPlaying = false;
  Timer? _posTimer;
  SoundHandle? _bgmCurrent;

  Future<void> init() async {
    try {
      await _soloud.init();
      _tap = await _load('assets/audio/placeholders/placeholder_sound.mp3');
      _ready = true;
    } catch (e) {
      _ready = false;
      if (kDebugMode) {
        print('AudioService init fallback: $e');
      }
    }
  }

  Future<AudioSource?> _load(String path) async {
    try {
      return await _soloud.loadAsset(path);
    } catch (e) {
      if (kDebugMode) {
        print('Audio load failed for $path: $e');
      }
      return null;
    }
  }

  Future<void> playTap() async {
    if (!_ready) return;
    if (_tap != null) {
      try {
        await _soloud.play(_tap!);
      } catch (_) {}
    }
  }

  Future<void> playNote(String id) async {
    if (!_ready) return;
    final key = id;
    var src = _cache[key];
    if (src == null) {
      src = await _load('assets/audio/final/$id.mp3');
      if (src != null) _cache[key] = src;
    }
    if (src != null) {
      try {
        await _soloud.play(src);
        return;
      } catch (_) {}
    }
    await playTap();
  }

  Future<void> playTick() async {
    await playNote('metronome_tick');
  }

  Future<void> startAmbient(String id) async {
    _ambientId = id;
    _ambientTimer?.cancel();
    await playNote(id);
    _ambientTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (_ambientId != null) {
        playNote(_ambientId!);
      }
    });
  }

  Future<void> stopAmbient() async {
    _ambientTimer?.cancel();
    _ambientTimer = null;
    _ambientId = null;
  }

  Future<void> dispose() async {
    try {
      await _soloud.deinit();
    } catch (_) {}
  }

  void _startPosTicker() {
    _posTimer?.cancel();
    _isPlaying = true;
    _posTimer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (!_isPlaying) return;
      final p = musicPosSec.value + 0.25;
      if (musicDurSec.value > 0 && p > musicDurSec.value) {
        musicPosSec.value = musicDurSec.value;
        _isPlaying = false;
      } else {
        musicPosSec.value = p;
      }
    });
  }

  void _stopPosTicker() {
    _isPlaying = false;
    _posTimer?.cancel();
    _posTimer = null;
  }

  void setMusicDuration(double sec) {
    musicDurSec.value = sec;
  }

  void resetMusicPosition() {
    musicPosSec.value = 0;
  }

  Future<void> pauseMusic() async {
    _isPlaying = false;
    if (_bgmCurrent != null) {
      try {
        await _soloud.setPause(_bgmCurrent!, true);
      } catch (_) {}
    }
  }

  Future<void> resumeMusic() async {
    if (_bgmCurrent != null) {
      try {
        await _soloud.setPause(_bgmCurrent!, false);
      } catch (_) {}
      _isPlaying = true;
    }
  }

  Future<void> seek(double seconds) async {
    musicPosSec.value = seconds.clamp(0, musicDurSec.value);
  }

  Future<void> playNarrationId(String id) async {
    if (!_ready) return;
    try {
      final story = getIt<StoryService>();
      final local = story.audioFileForId(id);
      if (local != null && local.isNotEmpty) {
        final src = await _soloud.loadFile(local);
        await _soloud.play(src);
        return;
      }
    } catch (_) {}
    await playNote(id);
  }

  get audioData => null;

  stopMusic() {}
}