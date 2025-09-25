import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';

import '../../../games/organ_game.dart';
import '../../../services/audio_engine_service.dart';
import '../../../services/gamification_bloc.dart';

/// Screen for the underwater organ instrument.
///
/// Shows colourful coral pipes and seashell keys.  Orientation is locked
/// to landscape and a back button allows returning to the previous page.
class OrganScreen extends StatefulWidget {
  const OrganScreen({super.key});

  @override
  State<OrganScreen> createState() => _OrganScreenState();
}

class _OrganScreenState extends State<OrganScreen> {
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
            game: OrganGame(
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