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
  StateMachineController? _controller;

  /// Initializes the Rive artboard and sets up the state machine controller.
  ///
  /// This method is invoked via the [RiveAnimation]'s `onInit` callback.  It
  /// loads the state machine named `InstrumentStateMachine`, attaches it to
  /// the artboard, and registers an event listener.  When events with the
  /// name `PLAY_SOUND` are reported, the [AudioService] is notified to
  /// play the corresponding sound.  The event's user data (a [String])
  /// should identify the sound (e.g. `PIANO_C4`).
  void _onRiveInit(Artboard artboard) {
    // Create the state machine controller from the artboard. If the
    // machine cannot be found, silently ignore events.
    final controller = StateMachineController.fromArtboard(
      artboard,
      'InstrumentStateMachine',
    );
    if (controller != null) {
      artboard.addController(controller);
      _controller = controller;
      // Register an event listener to handle events reported by the
      // state machine. The callback receives a [RiveEvent] object. The
      // user data accompanying the event is not strongly typed on older
      // versions of the runtime, so we cast dynamically when accessing it.
      controller.addEventListener((RiveEvent event) {
        // Attempt to extract the userData from the event. In Rive
        // 0.13.x the event does not expose a `data` getter and may
        // instead store arbitrary user data on a `userData` property.
        dynamic userData;
        try {
          // The `userData` field is only present on general events.
          userData = (event as dynamic).userData;
        } catch (_) {
          userData = null;
        }
        if (event.name == 'PLAY_SOUND' && userData is String) {
          final soundId = userData as String;
          ref.read(audioServiceProvider).playInstrumentSound(soundId);
        }
      });
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
            stateMachines: const ['InstrumentStateMachine'],
            fit: BoxFit.contain,
            // Use the default hit test behavior (opaque) to allow
            // interactions. Pointer events are captured by default; there is
            // no need for an `enablePointerEvents` parameter on
            // `RiveAnimation` in this runtime version.
            onInit: _onRiveInit,
          ),
        ),
      ),
    );
  }
}