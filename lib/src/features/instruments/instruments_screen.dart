import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart';

import '../../services/audio_service.dart';

class InstrumentsScreen extends ConsumerStatefulWidget {
  const InstrumentsScreen({super.key});

  @override
  ConsumerState<InstrumentsScreen> createState() => _InstrumentsScreenState();
}

class _InstrumentsScreenState extends ConsumerState<InstrumentsScreen> {
  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'InstrumentStateMachine',
    );
    if (controller != null) {
      artboard.addController(controller);
      controller.addEventListener((RiveEvent event) {
        dynamic userData;
        try {
          userData = (event as dynamic).userData;
        } catch (_) {
          userData = null;
        }

        if (event.name == 'PLAY_SOUND' && userData is String) {
          final soundId = userData.toLowerCase();
          final audioPath = 'assets/audio/instrumente/$soundId.mp3';
          ref.read(audioServiceProvider).play(audioPath, channel: AudioChannel.sfx);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            onInit: _onRiveInit,
          ),
        ),
      ),
    );
  }
}
