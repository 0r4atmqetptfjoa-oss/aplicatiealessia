import 'package:flutter/material.dart';
// import 'package:rive/rive.dart'; // Activează când adaugi fișierul .riv

class ZanaMelodiaOverlay extends StatelessWidget {
  final ValueListenable<String> animationListenable;
  const ZanaMelodiaOverlay({super.key, required this.animationListenable});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // TODO (Răzvan): Înlocuiește cu animația Rive 'zana_melodia.riv'
                Image.asset('assets/images/placeholders/placeholder_square.png', width: 40, height: 40),
                const SizedBox(width: 8),
                ValueListenableBuilder<String>(
                  valueListenable: animationListenable,
                  builder: (_, v, __) => Text('Zâna: $v', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
