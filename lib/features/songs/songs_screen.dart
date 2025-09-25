import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart';

/// Screen displaying the interactive song player with a Rive character.
///
/// This widget loads a Rive animation from disk and controls its state
/// machine in response to user interactions.  When a song is played,
/// the fairy "Zâna Melodia" switches between slow and fast dance
/// animations or finishes with a bow.  The actual Rive file should
/// define a state machine with boolean or trigger inputs named
/// 'idle', 'dance_slow', 'dance_fast' and 'ending_pose'.
class SongsScreen extends StatefulWidget {
  const SongsScreen({super.key});

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  Artboard? _artboard;
  StateMachineController? _stateMachine;
  SMIInput<bool>? _idle;
  SMIInput<bool>? _danceSlow;
  SMIInput<bool>? _danceFast;
  SMIInput<bool>? _endingPose;

  @override
  void initState() {
    super.initState();
    _loadRiveFile();
  }

  Future<void> _loadRiveFile() async {
    final ByteData data = await rootBundle.load('assets/animations/zana_melodia.riv');
    final file = RiveFile.import(data);
    final artboard = file.mainArtboard;
    // Attempt to attach the state machine controller.  Replace
    // 'State Machine 1' with the actual state machine name from your Rive
    // file if different.
    final controller = StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (controller != null) {
      artboard.addController(controller);
      // Retrieve named inputs.  These must match the names defined in
      // the Rive state machine.  If not found they remain null.
      _idle = controller.findInput('idle');
      _danceSlow = controller.findInput('dance_slow');
      _danceFast = controller.findInput('dance_fast');
      _endingPose = controller.findInput('ending_pose');
    }
    setState(() {
      _artboard = artboard;
      _stateMachine = controller;
    });
  }

  void _setAnimation(String name) {
    // Clear all booleans first.
    _idle?.value = false;
    _danceSlow?.value = false;
    _danceFast?.value = false;
    _endingPose?.value = false;
    switch (name) {
      case 'idle':
        _idle?.value = true;
        break;
      case 'dance_slow':
        _danceSlow?.value = true;
        break;
      case 'dance_fast':
        _danceFast?.value = true;
        break;
      case 'ending_pose':
        _endingPose?.value = true;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cântece'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _artboard == null
                ? const Center(child: CircularProgressIndicator())
                : Rive(artboard: _artboard!),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 12,
              children: [
                ElevatedButton(
                  onPressed: () => _setAnimation('idle'),
                  child: const Text('Idle'),
                ),
                ElevatedButton(
                  onPressed: () => _setAnimation('dance_slow'),
                  child: const Text('Dans Lent'),
                ),
                ElevatedButton(
                  onPressed: () => _setAnimation('dance_fast'),
                  child: const Text('Dans Rapid'),
                ),
                ElevatedButton(
                  onPressed: () => _setAnimation('ending_pose'),
                  child: const Text('Final'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}