import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../services/tts_service.dart';
import '../../services/image_generation_service.dart';

/// Screen responsible for playing narrated stories with accompanying
/// illustrations.
///
/// This widget presents one paragraph at a time from a predefined
/// story.  When the user taps the "Redă" (play) button, the
/// paragraph is spoken aloud via the [TtsService], and an image
/// selected by the [ImageGenerationService] is displayed with a
/// smooth fade transition.  The user can advance through the story
/// paragraphs with the "Următor" (next) button.
class StoriesScreen extends StatefulWidget {
  const StoriesScreen({super.key});

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  final List<String> _storyParagraphs = const <String>[
    'A fost odată ca niciodată o pădure fermecată, plină de luminițe ce zburdau printre copaci. În mijlocul ei trăia o mică zână curajoasă pe nume Alesia, care iubea să asculte muzica naturii.',
    'Într-o zi, Alesia a întâlnit un iepuraș trist și un căprioară speriată. Ei i-au povestit că un nor întunecat acoperea castelul din depărtare și nu mai auzeau cântecele păsărilor.',
    'Hotărâtă să aducă iarăși bucuria, Alesia a pornit spre castel. Pe drum, prietenii ei s-au alăturat, iar împreună au cântat atât de frumos încât norul cel negru s-a risipit, iar soarele a luminat din nou pământul.',
  ];

  final TtsService _ttsService = TtsService();
  final ImageGenerationService _imageGenerationService = ImageGenerationService();
  int _currentIndex = 0;
  String? _currentImage;

  @override
  void initState() {
    super.initState();
    // Lock orientation to portrait for the stories screen.
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _updateImage();
  }

  @override
  void dispose() {
    // Restore preferred orientations when leaving the screen.
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  /// Update the image based on the current paragraph.
  void _updateImage() {
    final String imagePath =
        _imageGenerationService.imageForText(_storyParagraphs[_currentIndex]);
    setState(() {
      _currentImage = imagePath;
    });
  }

  /// Initiates TTS playback for the current paragraph.
  Future<void> _playCurrent() async {
    final String text = _storyParagraphs[_currentIndex];
    await _ttsService.speak(text);
  }

  /// Advance to the next paragraph if possible.
  void _next() {
    if (_currentIndex < _storyParagraphs.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _updateImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final String currentText = _storyParagraphs[_currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Povești'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _currentImage == null
                  ? const Center(child: CircularProgressIndicator())
                  : AnimatedSwitcher(
                      duration: const Duration(milliseconds: 600),
                      child: Image.asset(
                        _currentImage!,
                        key: ValueKey<String>(_currentImage!),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                currentText,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _playCurrent,
                    child: const Text('Redă'),
                  ),
                  ElevatedButton(
                    onPressed: _currentIndex < _storyParagraphs.length - 1 ? _next : null,
                    child: const Text('Următor'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}