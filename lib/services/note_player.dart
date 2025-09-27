import 'package:alesia/services/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

/// Enum simplu pentru note (octava 4).
enum Note { C4, D4, E4, F4, G4, A4, B4 }

/// Redă note reale când fișierele sunt disponibile în `assets/audio/final/notes/`,
/// altfel cade pe placeholder (click) prin AudioService.
class NotePlayer {
  final SoLoud _soloud = SoLoud.instance;
  final AudioService _audioService;

  /// Cache pentru surse – cheie: numele fișierului (ex: 'C4.mp3')
  final Map<String, AudioSource> _cache = {};

  NotePlayer(this._audioService);

  Future<void> preloadAll() async {
    for (final n in Note.values) {
      await _ensureLoaded(_fileFor(n));
    }
  }

  Future<void> play(Note note, {double volume = 1.0}) async {
    final file = _fileFor(note);
    try {
      final src = await _ensureLoaded(file);
      await _soloud.play(src, volume: volume);
    } catch (e) {
      // Placeholder fallback
      if (kDebugMode) {
        print('Note $note not found, fallback to tap: $e');
      }
      await _audioService.playTap();
    }
  }

  String _fileFor(Note n) => 'assets/audio/final/notes/${_name(n)}.mp3';

  String _name(Note n) {
    switch (n) {
      case Note.C4: return 'C4';
      case Note.D4: return 'D4';
      case Note.E4: return 'E4';
      case Note.F4: return 'F4';
      case Note.G4: return 'G4';
      case Note.A4: return 'A4';
      case Note.B4: return 'B4';
    }
  }

  Future<AudioSource> _ensureLoaded(String assetPath) async {
    if (_cache.containsKey(assetPath)) return _cache[assetPath]!;
    final src = await _soloud.loadAsset(assetPath);
    _cache[assetPath] = src;
    return src;
  }
}
