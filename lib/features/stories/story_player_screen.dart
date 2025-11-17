import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:go_router/go_router.dart';

import '../../models/story.dart';

/// Screen that plays a selected story with audio narration and images.
///
/// The screen expects a [Story] to be passed via [GoRouterState.extra]. It
/// displays a 3D animated title, an animated subtitle prompting the user to
/// listen, and a carousel of images that advance automatically while the
/// narration plays. A play/pause button allows the user to control
/// playback. When the story finishes the button resets to allow replay.
class StoryPlayerScreen extends StatefulWidget {
  const StoryPlayerScreen({super.key});

  @override
  State<StoryPlayerScreen> createState() => _StoryPlayerScreenState();
}

class _StoryPlayerScreenState extends State<StoryPlayerScreen> {
  late final Story story;
  late final AudioPlayer _player;
  int _currentImageIndex = 0;
  Timer? _imageTimer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
  }

  @override
  void dispose() {
    _player.dispose();
    _imageTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve the story from the route extras. If no story is provided,
    // fallback to a default story to avoid null errors.
    final extra = GoRouterState.of(context).extra;
    if (extra is Story) {
      story = extra;
    } else {
      story = const Story(
        title: 'Unknown Story',
        imagePaths: [],
        audioPath: '',
      );
    }
  }

  /// Start playing the story audio and schedule image changes.
  Future<void> _startPlayback() async {
    if (_isPlaying || story.audioPath.isEmpty) return;
    try {
      // Load and play the local asset. The package automatically handles
      // caching and reading from the asset bundle.
      await _player.play(AssetSource(story.audioPath));
      setState(() {
        _isPlaying = true;
        _currentImageIndex = 0;
      });
      // Determine how long each image should display. If the player is
      // unable to determine the duration, default to 4 seconds per image.
      final duration = await _player.getDuration();
      final totalMs = duration?.inMilliseconds ?? (story.imagePaths.length * 4000);
      final perImageMs = story.imagePaths.isEmpty
          ? totalMs
          : (totalMs / story.imagePaths.length).floor();
      // Cancel any existing timer and start a new one.
      _imageTimer?.cancel();
      _imageTimer = Timer.periodic(Duration(milliseconds: perImageMs), (timer) {
        setState(() {
          _currentImageIndex++;
          if (_currentImageIndex >= story.imagePaths.length) {
            _currentImageIndex = story.imagePaths.length - 1;
          }
        });
      });
      // Listen for completion to reset state.
      _player.onPlayerComplete.listen((event) {
        _imageTimer?.cancel();
        setState(() {
          _isPlaying = false;
          _currentImageIndex = story.imagePaths.isNotEmpty ? story.imagePaths.length - 1 : 0;
        });
      });
    } catch (_) {
      // If an error occurs (e.g. file not found) just reset state.
      setState(() {
        _isPlaying = false;
      });
    }
  }

  /// Pause playback. This stops the audio and cancels the image timer.
  Future<void> _pausePlayback() async {
    await _player.pause();
    _imageTimer?.cancel();
    setState(() {
      _isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(story.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 3D animated title for stories
            SizedBox(
              height: 150,
              child: ModelViewer(
                src: 'assets/models/stories/title.glb',
                alt: 'Story Title',
                autoPlay: true,
                autoRotate: true,
                disableZoom: true,
                backgroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 8),
            // Subtitle encouraging listening
            Text(
              'Listen and watch the story!',
              // subtitle1 -> titleMedium【259856227738898†L509-L519】.
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Image carousel
            Expanded(
              child: story.imagePaths.isEmpty
                  ? const Center(child: Text('No images available'))
                  : Image.asset(
                      story.imagePaths[_currentImageIndex.clamp(0, story.imagePaths.length - 1)],
                      fit: BoxFit.contain,
                    ),
            ),
            const SizedBox(height: 16),
            // Playback controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _isPlaying ? _pausePlayback : _startPlayback,
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  label: Text(_isPlaying ? 'Pause' : 'Play'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}