/// Model class representing a story with audio narration and illustration.
///
/// Each story consists of a title, a list of image asset paths used to
/// illustrate the story, and an audio asset path containing the narration.
/// The [imagePaths] should point to files under `assets/stories/` and
/// the [audioPath] should reference a file under `assets/audio/`. When
/// playing a story the images can be shown sequentially while the
/// narration plays. You can extend this model with additional metadata
/// such as durations or captions.
class Story {
  /// Human‑readable title of the story (e.g. “The Little Cat”).
  final String title;

  /// List of image asset paths illustrating the story.
  final List<String> imagePaths;

  /// Path to the audio narration asset.
  final String audioPath;

  const Story({
    required this.title,
    required this.imagePaths,
    required this.audioPath,
  });
}