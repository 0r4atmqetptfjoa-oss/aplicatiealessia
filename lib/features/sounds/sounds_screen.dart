import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/game.dart';

import '../../games/sounds_game.dart';

/// Screen that embeds the [SoundsGame] inside a Flutter widget tree.
///
/// This screen locks orientation to portrait and provides a basic
/// navigation bar.  The child [GameWidget] renders the interactive
/// sound map scene defined in [SoundsGame].
class SoundsScreen extends StatefulWidget {
  const SoundsScreen({super.key});

  @override
  State<SoundsScreen> createState() => _SoundsScreenState();
}

class _SoundsScreenState extends State<SoundsScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sunete'),
        leading: BackButton(onPressed: () => Navigator.of(context).pop()),
      ),
      body: GameWidget(game: SoundsGame()),
    );
  }
}