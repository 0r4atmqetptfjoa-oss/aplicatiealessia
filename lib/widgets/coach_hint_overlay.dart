import 'package:alesia/core/service_locator.dart';
import 'package:alesia/games/common/rhythm_coach.dart';
import 'package:alesia/services/ab_test_service.dart';
import 'package:flutter/material.dart';

class CoachHintOverlay extends StatelessWidget {
  final ValueListenable<RhythmState> stateListenable;
  const CoachHintOverlay({super.key, required this.stateListenable});

  @override
  Widget build(BuildContext context) {
    final variant = getIt<ABTestService>().assign('CoachHints', const ['sticky', 'dismissable']);
    final child = ValueListenableBuilder<RhythmState>(
      valueListenable: stateListenable,
      builder: (context, st, _) {
        final msg = switch (st.phase) {
          RhythmPhase.demo => 'Ascultă cu atenție modelul 🎧',
          RhythmPhase.user => 'Repetă modelul – încearcă pas cu pas 👣',
          RhythmPhase.success => 'Bravo! Pregătește-te pentru următorul ⭐',
          RhythmPhase.fail => 'Nicio problemă, hai din nou 😊',
          _ => 'Începe lecția când ești gata',
        };
        return Material(
          color: Colors.white.withOpacity(0.9),
          elevation: 6,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(msg, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        );
      },
    );

    if (variant == 'sticky') {
      return Positioned(
        bottom: 12, left: 12, right: 12,
        child: child,
      );
    } else {
      return Positioned(
        bottom: 12, left: 12,
        child: Dismissible(
          key: const ValueKey('coach_hint'),
          direction: DismissDirection.horizontal,
          child: child,
        ),
      );
    }
  }
}
