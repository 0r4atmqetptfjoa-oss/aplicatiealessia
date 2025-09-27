import 'package:alesia/games/instruments/drums_game.dart';
import 'package:alesia/widgets/rhythm_overlay.dart';
import 'package:alesia/widgets/zana_melodia_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

class DrumsScreen extends StatelessWidget {
  const DrumsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = DrumsGame();
    return Scaffold(
      appBar: AppBar(title: const Text('Drums')),
      body: GameWidget(
        game: game,
        overlayBuilderMap: {
          'HintHUD': (context, gameRef) => CoachHintOverlay(stateListenable: (gameRef as DrumsGame).coachState),
          'RhythmHUD': (context, gameRef) => RhythmOverlay(
                stateListenable: (gameRef as DrumsGame).coachState,
                beatListenable: (gameRef as DrumsGame).beatListenable,
                onStart: (gameRef as DrumsGame).startCoach,
                onStop: (gameRef as DrumsGame).stopCoach,
                onTempoUp: (gameRef as DrumsGame).tempoUp,
                onTempoDown: (gameRef as DrumsGame).tempoDown,
                onToggleMetronome: (gameRef as DrumsGame).toggleMetronome,
                onStartRec: (gameRef as DrumsGame).startRec,
                onStopRec: (gameRef as DrumsGame).stopRec,
                onPlayRec: (gameRef as DrumsGame).playRec,
                onClearRec: (gameRef as DrumsGame).clearRec,
              ),
          'ZanaHUD': (context, gameRef) => ZanaMelodiaOverlay(
                animationListenable: (gameRef as DrumsGame).zanaAnimation,
              ),
        },
      ),
    );
  }
}
