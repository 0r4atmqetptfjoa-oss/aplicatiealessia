import 'package:flutter/material.dart';

/// Placeholder screen for the instruments module.
///
/// In later phases this will load a Rive 3D scene and handle multitouch
/// interaction.  For now it simply displays a message so that routing works.
class InstrumentsScreen extends StatelessWidget {
  const InstrumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: null,
      body: Center(
        child: Text('Instruments Module (Landscape Only)'),
      ),
    );
  }
}