import 'package:alesia/games/instruments/organ_game.dart';
import 'package:alesia/widgets/rhythm_overlay.dart';
import 'package:alesia/widgets/zana_melodia_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

class OrganScreen extends StatelessWidget {
  const OrganScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = OrganGame();
    return Scaffold(
      appBar: AppBar(title: const Text('Organ')),
      body: GameWidget(
        game: game,
        overlayBuilderMap: {
          'HintHUD': (context, gameRef) => CoachHintOverlay(stateListenable: (gameRef as OrganGame).coachState),
          'RhythmHUD': (context, gameRef) => RhythmOverlay(
                stateListenable: (gameRef as OrganGame).coachState,
                beatListenable: (gameRef as OrganGame).beatListenable,
                onStart: (gameRef as OrganGame).startCoach,
                onStop: (gameRef as OrganGame).stopCoach,
                onTempoUp: (gameRef as OrganGame).tempoUp,
                onTempoDown: (gameRef as OrganGame).tempoDown,
                onToggleMetronome: (gameRef as OrganGame).toggleMetronome,
                onStartRec: (gameRef as OrganGame).startRec,
                onStopRec: (gameRef as OrganGame).stopRec,
                onPlayRec: (gameRef as OrganGame).playRec,
                onClearRec: (gameRef as OrganGame).clearRec,
              ),
          'ZanaHUD': (context, gameRef) => ZanaMelodiaOverlay(
                animationListenable: (gameRef as OrganGame).zanaAnimation,
              ),
        },
      ),
    );
  }
}
