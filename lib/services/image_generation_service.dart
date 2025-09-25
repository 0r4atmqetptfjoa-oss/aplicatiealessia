import 'dart:math' as math;

/// A lightweight service that selects an appropriate illustration
/// for a given piece of story text.
///
/// This implementation does not perform real AI image generation but
/// instead chooses from a small set of pre‑generated Pixar‑style
/// images included in the app's assets.  The selection is based on
/// a hash of the provided text to produce a deterministic yet varied
/// mapping across paragraphs.
class ImageGenerationService {
  ImageGenerationService._internal();

  static final ImageGenerationService _instance =
      ImageGenerationService._internal();

  /// Access the shared instance of the service.
  factory ImageGenerationService() => _instance;

  /// List of available story illustration assets.  These files live
  /// under `assets/images/stories/` and are bundled with the app.
  static const List<String> _storyImages = <String>[
    'assets/images/stories/story_scene_1.png',
    'assets/images/stories/story_scene_2.png',
    'assets/images/stories/story_scene_3.png',
  ];

  /// Returns an asset path for an image matching the [text].
  ///
  /// The mapping uses [text.hashCode] to ensure that the same
  /// paragraph always returns the same image.  If the list of
  /// available images changes, this mapping will be rebalanced.
  String imageForText(String text) {
    if (_storyImages.isEmpty) {
      throw StateError('No story images configured');
    }
    final int index = text.hashCode.abs() % _storyImages.length;
    return _storyImages[index];
  }
}