import 'package:alesia/games/instruments/xylophone.dart';
import 'package:alesia/widgets/rhythm_overlay.dart';
import 'package:alesia/widgets/zana_melodia_overlay.dart';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

class XylophoneScreen extends StatefulWidget {
  const XylophoneScreen({super.key});

  @override
  State<XylophoneScreen> createState() => _State();
}

class _State extends State<XylophoneScreen> {
  late final XylophoneGame game;

  @override
  void initState() {
    super.initState();
    game = XylophoneGame();
    // TODO (Răzvan): Înlocuiește cu muzica de fundal finală pentru acest instrument: assets/audio/final/bg_xylophone_loop.mp3
    getIt<AudioService>().startAmbient('bg_xylophone_loop');
  }

  @override
  void dispose() {
    getIt<AudioService>().stopAmbient();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Xylophone')),
      body: GameWidget(
        game: game,
        overlayBuilderMap: {
          'RhythmHUD': (context, gameRef) => RhythmOverlay(
                stateListenable: game.coachState,
                onStart: game.startCoach,
                onStop: game.stopCoach,
                onToggleRecord: game.startRecordOrStop,
                onPlayRecording: game.playRecording,
                onTempoChange: game.setBpm,
                onMetronomeToggle: game.toggleMetronome,
                beatListenable: game.beat,
                bpmListenable: game.bpm,
                recordingListenable: ValueNotifier(game.recorder.isRecording),
                hasRecordingListenable: ValueNotifier(game.recorder.hasRecording),
                metronomeOnListenable: game.metronomeOn,
              ),
          'ZanaHUD': (context, gameRef) => ZanaMelodiaOverlay(animationListenable: game.zanaAnimation),
          'HintsHUD': (context, gameRef) {
            final variant = getIt<ABTestService>().assign('StickyCoachHints', const ['off', 'on']);
            return HintsOverlay(stateListenable: (gameRef as XylophoneGame).coachState, sticky: variant == 'on');
          },
        },
      ),
    );
  }
}
