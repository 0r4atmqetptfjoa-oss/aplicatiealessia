import 'package:alesia/games/instruments/drums_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:alesia/widgets/zana_melodia_overlay.dart';
import 'package:alesia/widgets/rhythm_overlay.dart';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/ab_test_service.dart';
import 'package:alesia/widgets/hints_overlay.dart';

class DrumsScreen extends StatefulWidget {
  const DrumsScreen({super.key});

  @override
  State<DrumsScreen> createState() => _State();
}

class _State extends State<DrumsScreen> {
  late final DrumsGame game;

  @override
  void initState() {
    super.initState();
    game = DrumsGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tobe')),
      body: GameWidget(
        game: game,
        overlayBuilderMap: {
          'Zana': (ctx, gameRef) {
            return ZanaMelodiaOverlay(animationListenable: (gameRef as DrumsGame).zana);
          },
          'Rhythm': (ctx, gameRef) {
            final g = gameRef as DrumsGame;
            return RhythmOverlay(
              stateListenable: g.coach.state,
              onStart: g.coach.start,
              onStop: g.coach.stop,
              onToggleRecord: g.recorder.toggle,
              onPlayRecording: g.recorder.play,
              onTempoChange: g.conductor.setBpm,
              onMetronomeToggle: g.metronome.toggle,
              beatListenable: g.conductor.beat,
              bpmListenable: g.conductor.bpm,
              recordingListenable: g.recorder.isRecording,
              hasRecordingListenable: g.recorder.hasRecording,
              metronomeOnListenable: g.metronome.isOn,
            );
          },
          'Hints': (ctx, gameRef) {
            final variant = getIt<ABTestService>().assign('StickyCoachHints', const ['off', 'on']);
            return HintsOverlay(stateListenable: (gameRef as DrumsGame).coach.state, sticky: variant == 'on');
          },
        },
      ),
    );
  }
}