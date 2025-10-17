import 'package:flutter/material.dart';

/// Plays a selected story video.
///
/// This placeholder displays the storyId.  The final version will
/// load and play a video file containing the narrated story.
class StoryPlayerScreen extends StatelessWidget {
  final String storyId;
  const StoryPlayerScreen({super.key, required this.storyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Redare Poveste')), 
      body: Center(
        child: Text('Reproducere poveste: $storyId'),
      ),
    );
  }
}