import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
class SongsScreen extends StatelessWidget {
  const SongsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cântece')),
      body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        // TODO (Răzvan): Înlocuiește cu grafică finală
        Image.asset('assets/images/placeholders/placeholder_landscape.png', width: 320),
        const SizedBox(height: 12),
        const Text('Modul Cântece (în lucru)'),
      ]).animate().fade(duration: 300.ms).scale(),),
    );
  }
}
