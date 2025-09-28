import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
class SoundsMapScreen extends StatelessWidget {
  const SoundsMapScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Harta Sunetelor')),
      body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        // TODO (Răzvan): Înlocuiește cu hartă finală interactivă
        Image.asset('assets/images/placeholders/placeholder_landscape.png', width: 320),
        const SizedBox(height: 12),
        const Text('Harta Sunetelor (în lucru)'),
      ]).animate().fade(duration: 300.ms).scale(),),
    );
  }
}
