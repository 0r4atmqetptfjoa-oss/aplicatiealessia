import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AudioChannel {
  soundEffect,
  music,
  voiceover,
}

class AudioService {
  final AudioPlayer _soundEffectPlayer = AudioPlayer();
  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _voiceoverPlayer = AudioPlayer();

  AudioService() {
    _musicPlayer.setReleaseMode(ReleaseMode.loop);
  }

  Future<void> play(String assetPath, {AudioChannel channel = AudioChannel.soundEffect}) async {
    AudioPlayer player;
    switch (channel) {
      case AudioChannel.soundEffect:
        player = _soundEffectPlayer;
        break;
      case AudioChannel.music:
        player = _musicPlayer;
        break;
      case AudioChannel.voiceover:
        player = _voiceoverPlayer;
        break;
    }

    // Stop any currently playing audio on the same channel
    await player.stop();
    
    // Play the new audio
    // The audioplayers package expects the path without the 'assets/' prefix
    await player.play(AssetSource(assetPath.replaceFirst('assets/', '')));
  }

  Future<void> stop(AudioChannel channel) async {
    switch (channel) {
      case AudioChannel.soundEffect:
        await _soundEffectPlayer.stop();
        break;
      case AudioChannel.music:
        await _musicPlayer.stop();
        break;
      case AudioChannel.voiceover:
        await _voiceoverPlayer.stop();
        break;
    }
  }

  void dispose() {
    _soundEffectPlayer.dispose();
    _musicPlayer.dispose();
    _voiceoverPlayer.dispose();
  }
}

final audioServiceProvider = Provider<AudioService>((ref) {
  final audioService = AudioService();
  ref.onDispose(() => audioService.dispose());
  return audioService;
});
