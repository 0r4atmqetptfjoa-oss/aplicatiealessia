import 'package:flutter/material.dart';

class HintsOverlay extends StatelessWidget {
  const HintsOverlay({super.key, required this.stateListenable, this.sticky = false});
  final ValueListenable<String> stateListenable;
  final bool sticky;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ValueListenableBuilder<String>(
              valueListenable: stateListenable,
              builder: (_, s, __) => Text('Hint: $s${sticky ? " (sticky)" : ""}'),
            ),
          ),
        ),
      ),
    );
  }
}
