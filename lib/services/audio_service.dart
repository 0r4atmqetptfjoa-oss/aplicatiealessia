import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

import 'dart:async';
class AudioService {
  final SoLoud _soloud = SoLoud.instance;
  final Map<String, AudioSource> _cache = {};
  AudioSource? _tap;
  bool _ready = false;
  Timer? _ambientTimer;
  String? _ambientId;

  Future<void> init() async {
    try {
      await _soloud.init();
      // TODO (Răzvan): Înlocuiește cu sunetul final, ex: 'assets/audio/final/tap.mp3'
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
      try { await _soloud.play(_tap!); } catch (_) {}
    }
  }

  /// Redă o notă după id (ex: 'piano_do4', 'xylo_c5', 'organ_c4', 'drum_snare').
  /// Va încerca `assets/audio/final/<id>.mp3`. Dacă nu există, folosește `playTap()` ca fallback.
  Future<void> playNote(String id) async {
    if (!_ready) return;
    final key = id;
    var src = _cache[key];
    if (src == null) {
      // TODO (Răzvan): Adaugă fișiere reale în `assets/audio/final/` cu denumirea exactă `<id>.mp3`
      src = await _load('assets/audio/final/$id.mp3');
      if (src != null) _cache[key] = src;
    }
    if (src != null) {
      try { await _soloud.play(src); return; } catch (_) {}
    }
    await playTap(); // fallback
  }

  /// Tick metronom (către `assets/audio/final/metronome_tick.mp3`), fallback pe tap.
  Future<void> playTick() async {
    await playNote('metronome_tick');
  }

  /// Ambianță / muzică de fundal: simulat periodic (fără loop nativ).
  /// ID-ul caută `assets/audio/final/<id>.mp3`.
  Future<void> startAmbient(String id) async {
    _ambientId = id;
    _ambientTimer?.cancel();
    // Redă imediat o dată
    await playNote(id);
    // Repetă aproximativ la 6 secunde
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

void setMusicDuration(double sec) { musicDurSec.value = sec; }
void resetMusicPosition() { musicPosSec.value = 0; }

Future<void> pauseMusic() async {
  _isPlaying = false;
  if (_bgmCurrent != null) {
    try { await _soloud.setPause(_bgmCurrent!, true); } catch (_) {}
  }
}

Future<void> resumeMusic() async {
  if (_bgmCurrent != null) {
    try { await _soloud.setPause(_bgmCurrent!, false); } catch (_) {}
    _isPlaying = true;
  }
}

Future<void> seekMusic(double seconds) async {
  // TODO (Răzvan): Dacă pluginul oferă seek, înlocuiește cu apelul real către SoLoud.
  musicPosSec.value = seconds.clamp(0, musicDurSec.value);
}

/// Redă narațiune după ID. Caută întâi în StoryService o mapare la fișier local,
/// apoi încearcă assets/audio/final/<id>.mp3, altfel degradează pe 'tap'.
Future<void> playNarrationId(String id) async {
  if (!_ready) return;
  try {
    final story = getIt<StoryService>();
    final local = story.audioFileForId(id);
    if (local != null && local.isNotEmpty) {
      final src = AudioSource.file(local);
      await _soloud.play(src);
      return;
    }
  } catch (_) {}
  // fallback pe asset
  await playNote(id);
}
