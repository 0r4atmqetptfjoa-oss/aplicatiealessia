import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:go_router/go_router.dart';

/// Screen that plays a selected story video.
///
/// This widget uses a [VideoPlayerController] to play a full narrated
/// video stored in the `assets/video/stories` folder.  The video loops
/// by default, and the user can control playback with a play/pause
/// button.  Story IDs correspond to the file names without extension.
class StoryPlayerScreen extends StatefulWidget {
  final String storyId;
  const StoryPlayerScreen({super.key, required this.storyId});

  @override
  State<StoryPlayerScreen> createState() => _StoryPlayerScreenState();
}

class _StoryPlayerScreenState extends State<StoryPlayerScreen> {
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    // Try to load from new stories directory; fallback to old 'povesti'
    final newPath = 'assets/video/stories/${widget.storyId}.mp4';
    _videoController = VideoPlayerController.asset(newPath)
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
    super.dispose();
  }

  void _togglePlayback() {
    if (!_isVideoInitialized) return;
    setState(() {
      _isPlaying = !_isPlaying;
    });
    if (_isPlaying) {
      _videoController.play();
    } else {
      _videoController.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.storyId.replaceAll('_', ' ').toUpperCase();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/stories'),
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
