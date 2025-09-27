import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/parental_control_service.dart';
import 'package:alesia/services/time_tracker_service.dart';
import 'package:flutter/material.dart';

class TimeBanner extends StatelessWidget {
  const TimeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final t = getIt<TimeTrackerService>();
    final p = getIt<ParentalControlService>();
    return ValueListenableBuilder<int>(
      valueListenable: t.elapsedMinutes,
      builder: (context, mins, _) {
        final limit = p.dailyMinutes;
        final over = limit > 0 && mins >= limit;
        return Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: over ? Colors.redAccent.withOpacity(0.9) : Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  limit > 0 ? 'Timp azi: $mins / $limit min' : 'Timp azi: $mins min',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
