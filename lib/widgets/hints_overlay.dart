import 'package:flutter/material.dart';
import 'package:alesia/widgets/rhythm_overlay.dart';

class HintsOverlay extends StatelessWidget {
  final ValueListenable<RhythmState> stateListenable;
  final bool sticky;
  const HintsOverlay({super.key, required this.stateListenable, required this.sticky});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black12)],
          ),
          child: ValueListenableBuilder<RhythmState>(
            valueListenable: stateListenable,
            builder: (context, s, _) {
              final show = sticky || s.phase != RhythmPhase.idle;
              return AnimatedOpacity(
                opacity: show ? 1 : 0,
                duration: const Duration(milliseconds: 250),
                child: Text(
                  s.message.isEmpty ? 'Gata de joacă!' : s.message,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
