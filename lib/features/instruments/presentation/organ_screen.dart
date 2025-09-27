import 'package:alesia/games/instruments/organ_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:alesia/widgets/zana_melodia_overlay.dart';
import 'package:alesia/widgets/rhythm_overlay.dart';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/ab_test_service.dart';
import 'package:alesia/widgets/hints_overlay.dart';

class OrganScreen extends StatefulWidget {
  const OrganScreen({super.key});

  @override
  State<OrganScreen> createState() => _State();
}

class _State extends State<OrganScreen> {
  late final OrganGame game;

  @override
  void initState() {
    super.initState();
    game = OrganGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orgă')),
      body: GameWidget(
        game: game,
        overlayBuilderMap: {
          'Zana': (ctx, gameRef) {
            return ZanaMelodiaOverlay(animationListenable: (gameRef as OrganGame).zana);
          },
          'Rhythm': (ctx, gameRef) {
            final g = gameRef as OrganGame;
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
            return HintsOverlay(stateListenable: (gameRef as OrganGame).coach.state, sticky: variant == 'on');
          },
        },
      ),
    );
  }
}