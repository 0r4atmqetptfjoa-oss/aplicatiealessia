import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Screen that plays a selected song.
///
/// Combines audio playback (from the `assets/audio/cantece/` folder) and
/// video playback (from the `assets/video/cantece/` folder) so that
/// music and animation are in sync.  The video loops by default and
/// the audio stops/starts when the user toggles the play/pause button.
class SongPlayerScreen extends StatefulWidget {
  final String songId;
  const SongPlayerScreen({super.key, required this.songId});

  @override
  State<SongPlayerScreen> createState() => _SongPlayerScreenState();
}

class _SongPlayerScreenState extends State<SongPlayerScreen> {
  late VideoPlayerController _videoController;
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isAudioLoaded = false;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initMedia();
  }

  Future<void> _initMedia() async {
    // Prepare audio.  Prefer .mp3; fall back to .wav if .mp3 is not available.
    final audioPathMp3 = 'assets/audio/cantece/${widget.songId}.mp3';
    final audioPathWav = 'assets/audio/cantece/${widget.songId}.wav';
    try {
      await _audioPlayer.setSource(AssetSource(audioPathMp3));
      _isAudioLoaded = true;
    } catch (_) {
      try {
        await _audioPlayer.setSource(AssetSource(audioPathWav));
        _isAudioLoaded = true;
      } catch (_) {
        // Ignore – audio remains unavailable.
      }
    }
    // Prepare video.
    final videoPath = 'assets/video/cantece/${widget.songId}_dance.mp4';
    _videoController = VideoPlayerController.asset(videoPath)
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
        });
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayback() {
    if (!_isAudioLoaded || !_isVideoInitialized) return;
    setState(() {
      _isPlaying = !_isPlaying;
    });
    if (_isPlaying) {
      _audioPlayer.resume();
      _videoController.play();
    } else {
      _audioPlayer.pause();
      _videoController.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.songId.replaceAll('_', ' ').toUpperCase();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          // Video display
          Expanded(
            child: Center(
              child: _isVideoInitialized
                  ? AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: VideoPlayer(_videoController),
                    )
                  : const CircularProgressIndicator(),
            ),
          ),
          // Controls
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 48,
                  icon: Icon(_isPlaying ? Icons.pause_circle : Icons.play_circle),
                  onPressed: (_isAudioLoaded && _isVideoInitialized) ? _togglePlayback : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}