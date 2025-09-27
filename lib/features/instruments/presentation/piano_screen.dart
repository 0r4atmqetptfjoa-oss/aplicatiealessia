import 'package:alesia/games/instruments/piano_game.dart';
import 'package:alesia/widgets/rhythm_overlay.dart';
import 'package:alesia/widgets/zana_melodia_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

class PianoScreen extends StatelessWidget {
  const PianoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = PianoGame();
    return Scaffold(
      appBar: AppBar(title: const Text('Piano')),
      body: GameWidget(
        game: game,
        overlayBuilderMap: {
          'HintHUD': (context, gameRef) => CoachHintOverlay(stateListenable: (gameRef as PianoGame).coachState),
          'RhythmHUD': (context, gameRef) => RhythmOverlay(
                stateListenable: (gameRef as PianoGame).coachState,
                beatListenable: (gameRef as PianoGame).beatListenable,
                onStart: (gameRef as PianoGame).startCoach,
                onStop: (gameRef as PianoGame).stopCoach,
                onTempoUp: (gameRef as PianoGame).tempoUp,
                onTempoDown: (gameRef as PianoGame).tempoDown,
                onToggleMetronome: (gameRef as PianoGame).toggleMetronome,
                onStartRec: (gameRef as PianoGame).startRec,
                onStopRec: (gameRef as PianoGame).stopRec,
                onPlayRec: (gameRef as PianoGame).playRec,
                onClearRec: (gameRef as PianoGame).clearRec,
              ),
          'ZanaHUD': (context, gameRef) => ZanaMelodiaOverlay(
                animationListenable: (gameRef as PianoGame).zanaAnimation,
              ),
        },
      ),
    );
  }
}
