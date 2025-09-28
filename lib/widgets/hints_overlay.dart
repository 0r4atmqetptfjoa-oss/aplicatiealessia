import 'package:flutter/material.dart';

class HintsOverlay extends StatelessWidget {
  final ValueListenable<String> stateListenable;
  final bool sticky;
  const HintsOverlay({super.key, required this.stateListenable, this.sticky = false});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: sticky ? Alignment.centerRight : Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.amber.shade100.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ValueListenableBuilder<String>(
              valueListenable: stateListenable,
              builder: (_, s, __) => Text('Hint: $s', style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ),
    );
  }
}
