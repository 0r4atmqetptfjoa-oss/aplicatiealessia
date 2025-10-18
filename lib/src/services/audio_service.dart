import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AudioChannel {
  music,
  sfx,
  voiceover,
}

class AudioService {
  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  final AudioPlayer _voiceoverPlayer = AudioPlayer();

  AudioService() {
    _musicPlayer.setReleaseMode(ReleaseMode.loop);
  }

  Future<void> play(String assetPath, {AudioChannel channel = AudioChannel.sfx}) async {
    AudioPlayer player;
    switch (channel) {
      case AudioChannel.music:
        player = _musicPlayer;
        _sfxPlayer.setVolume(0.2);
        _voiceoverPlayer.setVolume(0.2);
        break;
      case AudioChannel.sfx:
        player = _sfxPlayer;
        break;
      case AudioChannel.voiceover:
        player = _voiceoverPlayer;
        _musicPlayer.setVolume(0.2);
        break;
    }

    await player.stop();
    await player.play(AssetSource(assetPath.replaceFirst('assets/', '')));
  }

  Future<void> playLocalized(String baseAssetPath, Locale locale, {AudioChannel channel = AudioChannel.voiceover}) async {
    final localizedPath = '${baseAssetPath}_${locale.languageCode}.mp3';
    await play(localizedPath, channel: channel);
  }

  Future<void> stop(AudioChannel channel) async {
    AudioPlayer player;
    switch (channel) {
      case AudioChannel.music:
        player = _musicPlayer;
        _sfxPlayer.setVolume(1.0);
        _voiceoverPlayer.setVolume(1.0);
        break;
      case AudioChannel.sfx:
        player = _sfxPlayer;
        break;
      case AudioChannel.voiceover:
        player = _voiceoverPlayer;
        _musicPlayer.setVolume(1.0);
        break;
    }
    await player.stop();
  }

  Future<void> crossfade(String newAssetPath, {Duration duration = const Duration(milliseconds: 300)}) async {
    await _musicPlayer.setVolume(0.0, duration: duration);
    await _musicPlayer.stop();
    await play(newAssetPath, channel: AudioChannel.music);
    await _musicPlayer.setVolume(1.0, duration: duration);
  }

  void dispose() {
    _musicPlayer.dispose();
    _sfxPlayer.dispose();
    _voiceoverPlayer.dispose();
  }
}

final audioServiceProvider = Provider<AudioService>((ref) {
  final audioService = AudioService();
  ref.onDispose(audioService.dispose);
  return audioService;
});
