import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';

import '../../../games/piano_game.dart';
import '../../../services/audio_engine_service.dart';
import '../../../services/gamification_bloc.dart';

/// Screen hosting the piano instrument.
///
/// This widget locks orientation to landscape while active and embeds
/// a [PianoGame] inside a standard [Scaffold].  A small back button
/// floats above the game to return to the previous page.  When the
/// widget is disposed the orientation is restored to portrait.
class PianoScreen extends StatefulWidget {
  const PianoScreen({super.key});

  @override
  State<PianoScreen> createState() => _PianoScreenState();
}

class _PianoScreenState extends State<PianoScreen> {
  @override
  void initState() {
    super.initState();
    // Force landscape orientation when this screen is shown.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Restore portrait orientation when leaving the screen.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audio = GetIt.instance.get<AudioEngineService>();
    final gamification = GetIt.instance.get<GamificationBloc>();
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GameWidget(
            game: PianoGame(
              audioService: audio,
              gamificationBloc: gamification,
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}