import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart';

import '../../services/audio_service.dart';

/// Instruments module screen.
///
/// This screen loads a 3D Rive scene containing the piano, xylophone and
/// drums.  When the user taps on an instrument key or drum, the Rive
/// state machine emits a `PLAY_SOUND` event with a string payload
/// identifying which sound to play (e.g. `PIANO_C4`).  The event
/// listener in this widget routes the sound ID to the [AudioService]
/// exposed via Riverpod.  Multitouch is natively supported by the
/// Rive runtime, so multiple instruments can be played simultaneously.
///
/// Note: The Rive file must be provided at
/// `assets/rive_3d/instruments_scene.riv` and include a state
/// machine named `InstrumentStateMachine`.  Additionally, a folder
/// `assets/audio/instrumente/` should contain .mp3 files named after
/// the lowercased event data (e.g. `piano_c4.mp3`).  During
/// development, placeholder files can be used; they will be
/// replaced with real assets later.
class InstrumentsScreen extends ConsumerStatefulWidget {
  const InstrumentsScreen({super.key});

  @override
  ConsumerState<InstrumentsScreen> createState() => _InstrumentsScreenState();
}

class _InstrumentsScreenState extends ConsumerState<InstrumentsScreen> {
  /// Handles Rive events fired from the 3D state machine.
  ///
  /// When the event name is `PLAY_SOUND`, the event's data is expected
  /// to be a [String] representing the instrument sound identifier.
  /// This callback forwards the identifier to the [AudioService] to
  /// play the corresponding sound.  Any other events are ignored.
  void _onRiveEvent(RiveEvent event) {
    if (event.name == 'PLAY_SOUND' && event.data is String) {
      final soundId = event.data as String;
      ref.read(audioServiceProvider).playInstrumentSound(soundId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Provide a transparent AppBar with a back button so users can
      // return to the menu.  The app bar only shows an icon; the
      // background is transparent to let the 3D scene fill the
      // viewport.
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/home'),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        color: Colors.black,
        child: Center(
          child: RiveAnimation.asset(
            'assets/rive_3d/instruments_scene.riv',
            // Ensure the state machine is active.
            stateMachines: const ['InstrumentStateMachine'],
            fit: BoxFit.contain,
            // Listen for events fired from the Rive file.
            onEvent: _onRiveEvent,
          ),
        ),
      ),
    );
  }
}