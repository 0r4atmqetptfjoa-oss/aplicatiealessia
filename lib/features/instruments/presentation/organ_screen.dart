import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flame/game.dart';

import '../../../games/instruments/organ_game.dart';

/// Screen for the organ instrument module. Forces landscape orientation while
/// in use and restores portrait when disposed.
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GameWidget(game: OrganGame()),
          Positioned(
            top: 16,
            left: 16,
            child: SafeArea(
              child: FloatingActionButton(
                mini: true,
                heroTag: 'back_organ',
                onPressed: () => GoRouter.of(context).pop(),
                child: const Icon(Icons.arrow_back),
              ),
            ),
          ),
        ],
      ),
    );
  }
}