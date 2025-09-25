import 'package:flutter_tts/flutter_tts.dart';

/// A simple service wrapping the [FlutterTts] plugin to provide
/// text‑to‑speech functionality for the stories module.
///
/// This service initialises a single [FlutterTts] instance and sets
/// appropriate language and voice parameters.  Currently it is
/// configured to use a Romanian female voice at a moderate rate and
/// pitch.  Methods return futures which can be awaited by callers.
class TtsService {
  TtsService._internal();

  static final TtsService _instance = TtsService._internal();

  /// Returns the shared instance of the service.
  factory TtsService() => _instance;

  final FlutterTts _flutterTts = FlutterTts();
  bool _initialised = false;

  /// Initialise the TTS engine if it hasn't been initialised yet.
  ///
  /// Sets the language to Romanian (ro‑RO) and attempts to select a
  /// female voice.  Also sets a comfortable speech rate and pitch.
  Future<void> _init() async {
    if (_initialised) return;
    // Set the language to Romanian.  Fallback to default if not supported.
    await _flutterTts.setLanguage('ro-RO');
    // Attempt to choose a female voice.  On some platforms this map
    // may need to be adjusted; keys are platform specific.  If the
    // requested voice is unavailable, the default voice is used.
    await _flutterTts.setVoice({
      'name': 'ro-ro-x-ro#female_1-local',
      'locale': 'ro-RO',
    });
    // Set moderate rate and pitch for a warm, calm narration.
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
    _initialised = true;
  }

  /// Speak the given [text] asynchronously.
  ///
  /// Callers should await this method to ensure that the speech
  /// completes before proceeding to the next segment.
  Future<void> speak(String text) async {
    await _init();
    await _flutterTts.stop();
    await _flutterTts.speak(text);
  }
}