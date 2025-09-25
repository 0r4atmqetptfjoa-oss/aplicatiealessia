import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';

import '../../../games/xylophone_game.dart';
import '../../../services/audio_engine_service.dart';
import '../../../services/gamification_bloc.dart';

/// Screen for the xylophone instrument.
///
/// Displays a row of glowing wooden bars that emit magical dust when
/// tapped.  Like other instrument screens, orientation is locked to
/// landscape and a back button overlays the game.
class XylophoneScreen extends StatefulWidget {
  const XylophoneScreen({super.key});

  @override
  State<XylophoneScreen> createState() => _XylophoneScreenState();
}

class _XylophoneScreenState extends State<XylophoneScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
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
            game: XylophoneGame(
              audioService: audio,
              gamificationBloc: gamification,
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          ),
        ],
      ),
    );
  }
}