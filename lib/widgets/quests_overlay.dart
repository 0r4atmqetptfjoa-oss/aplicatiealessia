import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/quests_service.dart';
import 'package:flutter/material.dart';

class QuestsOverlay extends StatelessWidget {
  final String instrument;
  const QuestsOverlay({super.key, required this.instrument});

  @override
  Widget build(BuildContext context) {
    final qs = getIt<QuestsService>().questsFor(instrument);
    if (qs.isEmpty) return const SizedBox.shrink();
    final q = qs.first;
    final progress = (q.progress / q.target).clamp(0, 1.0);
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black26)],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.flag),
              const SizedBox(width: 8),
              Text(q.title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(width: 12),
              SizedBox(width: 100, child: LinearProgressIndicator(value: progress)),
              const SizedBox(width: 8),
              Text('${q.progress}/${q.target}'),
            ],
          ),
        ),
      ),
    );
  }
}
