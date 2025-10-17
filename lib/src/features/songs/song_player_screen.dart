import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/audio_service.dart';

class SongPlayerScreen extends ConsumerStatefulWidget {
  final String songId;
  const SongPlayerScreen({super.key, required this.songId});

  @override
  ConsumerState<SongPlayerScreen> createState() => _SongPlayerScreenState();
}

class _SongPlayerScreenState extends ConsumerState<SongPlayerScreen> {
  late VideoPlayerController _videoController;
  bool _isPlaying = false;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initMedia();
  }

  Future<void> _initMedia() async {
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
    // Stop music on dispose
    ref.read(audioServiceProvider).stop(AudioChannel.music);
    super.dispose();
  }

  void _togglePlayback() {
    if (!_isVideoInitialized) return;

    final audioService = ref.read(audioServiceProvider);
    final audioPath = 'assets/audio/cantece/${widget.songId}.mp3';

    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      audioService.play(audioPath, channel: AudioChannel.music);
      _videoController.play();
    } else {
      audioService.stop(AudioChannel.music);
      _videoController.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.songId.replaceAll('_', ' ').toUpperCase();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/songs'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => context.go('/home'),
          ),
        ],
      ),
      body: Column(
        children: [
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 48,
                  icon: Icon(_isPlaying ? Icons.pause_circle : Icons.play_circle),
                  onPressed: _isVideoInitialized ? _togglePlayback : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
