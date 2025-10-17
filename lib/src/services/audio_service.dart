import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A simple audio service for playing instrument sounds.
///
/// This service maintains a pool of [AudioPlayer] instances so that
/// multiple sounds can play simultaneously.  When an instrument
/// triggers a sound via a Rive event, the [playInstrumentSound]
/// method should be called with the sound identifier (e.g. `PIANO_C4`).
/// The service will construct the correct asset path and play the
/// sound.  If you later adjust the naming convention or file
/// locations, update [_resolveAssetPath] accordingly.
class AudioService {
  // A list of active audio players.  When a new sound is played
  // concurrently, a new player is created and disposed when
  // playback completes.  You could reuse players for repeated
  // playback of the same sound if latency becomes an issue.
  final List<AudioPlayer> _activePlayers = [];

  /// Plays an instrument sound with the given [soundId].
  ///
  /// The [soundId] should match the data passed via the Rive
  /// event (e.g. `PIANO_C4`, `DRUM_BASS`, `XYLO_G`).  This method
  /// resolves the asset path and plays the sound.  Any errors
  /// during playback are silently ignored.  To debug audio issues
  /// you can add logging here.
  Future<void> playInstrumentSound(String soundId) async {
    final player = AudioPlayer();
    _activePlayers.add(player);
    final path = _resolveAssetPath(soundId);
    try {
      await player.play(AssetSource(path));
    } catch (_) {
      // Ignored: audio file might be missing; real assets will be
      // provided later.  Consider logging the error when
      // debugging.
    } finally {
      // Remove the player after playback completes.  A short delay
      // allows the sound to finish before disposing.
      player.onPlayerComplete.listen((_) {
        _activePlayers.remove(player);
        player.dispose();
      });
    }
  }

  /// Constructs the asset path for a given [soundId].
  ///
  /// By default, instrument audio files are stored under
  /// `assets/audio/instrumente/` and use a lowercase version of the
  /// sound identifier.  For example `PIANO_C4` ->
  /// `assets/audio/instrumente/piano_c4.mp3`.  You can customize
  /// this method if your naming convention differs.
  String _resolveAssetPath(String soundId) {
    final filename = soundId.toLowerCase();
    return 'assets/audio/instrumente/$filename.mp3';
  }
}

/// A [Provider] that exposes a shared instance of [AudioService].
///
/// Use `ref.read(audioServiceProvider)` to obtain the service and
/// call [AudioService.playInstrumentSound] when a Rive event is
/// received.  Since [AudioService] does not depend on other
/// providers, a simple [Provider] is sufficient here.
final audioServiceProvider = Provider<AudioService>((ref) {
  return AudioService();
});