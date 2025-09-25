import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';

import '../../../games/drums_game.dart';
import '../../../services/audio_engine_service.dart';
import '../../../services/gamification_bloc.dart';

/// Screen hosting the drums instrument.
///
/// Locks the orientation to landscape and shows a row of gummy drums
/// that the child can tap.  A back button floats on top to allow
/// returning to the previous screen.
class DrumsScreen extends StatefulWidget {
  const DrumsScreen({super.key});

  @override
  State<DrumsScreen> createState() => _DrumsScreenState();
}

class _DrumsScreenState extends State<DrumsScreen> {
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
            game: DrumsGame(
              audioService: audio,
              gamificationBloc: gamification,
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}