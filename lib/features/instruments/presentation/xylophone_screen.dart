import 'package:alesia/games/instruments/xylophone_game.dart';
import 'package:alesia/widgets/rhythm_overlay.dart';
import 'package:alesia/widgets/zana_melodia_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

class XylophoneScreen extends StatelessWidget {
  const XylophoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = XylophoneGame();
    return Scaffold(
      appBar: AppBar(title: const Text('Xylophone')),
      body: GameWidget(
        game: game,
        overlayBuilderMap: {
          'HintHUD': (context, gameRef) => CoachHintOverlay(stateListenable: (gameRef as XylophoneGame).coachState),
          'RhythmHUD': (context, gameRef) => RhythmOverlay(
                stateListenable: (gameRef as XylophoneGame).coachState,
                beatListenable: (gameRef as XylophoneGame).beatListenable,
                onStart: (gameRef as XylophoneGame).startCoach,
                onStop: (gameRef as XylophoneGame).stopCoach,
                onTempoUp: (gameRef as XylophoneGame).tempoUp,
                onTempoDown: (gameRef as XylophoneGame).tempoDown,
                onToggleMetronome: (gameRef as XylophoneGame).toggleMetronome,
                onStartRec: (gameRef as XylophoneGame).startRec,
                onStopRec: (gameRef as XylophoneGame).stopRec,
                onPlayRec: (gameRef as XylophoneGame).playRec,
                onClearRec: (gameRef as XylophoneGame).clearRec,
              ),
          'ZanaHUD': (context, gameRef) => ZanaMelodiaOverlay(
                animationListenable: (gameRef as XylophoneGame).zanaAnimation,
              ),
        },
      ),
    );
  }
}
