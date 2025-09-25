import 'dart:math' as math;
import 'package:flutter_soloud/flutter_soloud.dart';

/// A singleton service responsible for playing audio for the instruments.
///
/// In later phases this service can load real sound files and trigger
/// them on demand.  At this point it simply initialises a [Soloud]
/// instance and provides stubbed methods for each type of instrument.
class AudioEngineService {
  AudioEngineService._internal();

  static final AudioEngineService _instance = AudioEngineService._internal();

  /// Access the shared instance of the service.
  factory AudioEngineService() => _instance;

  final Soloud _soloud = Soloud();

  bool _initialised = false;

  /// Initialise the underlying audio engine.
  Future<void> init() async {
    if (_initialised) return;
    await _soloud.init();
    _initialised = true;
  }

  /// Play a piano key sound for the given [index].
  ///
  /// In a production version this would load and play a sampled note
  /// corresponding to the key index.  For now it simply triggers a short
  /// sine tone via the Soloud API.
  void playPianoKey(int index) {
    if (!_initialised) return;
    final double freq = 220.0 * (1 << (index ~/ 12)) *
        _pitchFactor(index % 12);
    final Sfxr sfx = Sfxr();
    sfx.setParamsString('sine&freq=$freq&decay=0.3');
    _soloud.play(sfx);
  }

  /// Play a drum hit corresponding to [index].
  void playDrum(int index) {
    if (!_initialised) return;
    final Sfxr sfx = Sfxr();
    sfx.setParamsString('square&freq=100&decay=0.2');
    _soloud.play(sfx);
  }

  /// Play a xylophone bar corresponding to [index].
  void playXylophone(int index) {
    if (!_initialised) return;
    final double base = 523.25; // C5
    final double freq = base * _pitchFactor(index);
    final Sfxr sfx = Sfxr();
    sfx.setParamsString('triangle&freq=$freq&decay=0.4');
    _soloud.play(sfx);
  }

  /// Play an organ key corresponding to [index].
  void playOrgan(int index) {
    if (!_initialised) return;
    final double base = 261.63; // C4
    final double freq = base * _pitchFactor(index);
    final Sfxr sfx = Sfxr();
    sfx.setParamsString('sine&freq=$freq&decay=0.5');
    _soloud.play(sfx);
  }

  /// Helper function returning a pitch multiplier for a semitone offset.
  double _pitchFactor(int semitone) {
    return math.pow(2.0, semitone / 12.0).toDouble();
  }
}