import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/progress_service.dart';
import 'package:alesia/services/quest_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class QuestsScreen extends StatefulWidget {
  const QuestsScreen({super.key});

  @override
  State<QuestsScreen> createState() => _QuestsScreenState();
}

class _QuestsScreenState extends State<QuestsScreen> {
  @override
  Widget build(BuildContext context) {
    final qs = getIt<QuestService>().quests;
    return Scaffold(
      appBar: AppBar(title: const Text('Misiuni & Recompense')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemCount: qs.length,
        itemBuilder: (context, i) {
          final q = qs[i];
          final progress = (q.progress / q.goal).clamp(0, 1.0);
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(q.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(q.description),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(value: progress),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${q.progress}/${q.goal}'),
                      ElevatedButton(
                        onPressed: q.claimed || q.progress < q.goal ? null : () async {
                          final ok = await getIt<QuestService>().claim(q.id);
                          if (ok) {
                            await getIt<ProgressService>().awardSticker(q.rewardSticker);
                            if (mounted) setState(() {});
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Sticker câștigat: ${q.rewardSticker}')),
                              );
                            }
                          }
                        },
                        child: Text(q.claimed ? 'Revendicat' : 'Revendică'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ).animate().fadeIn().scale();
        },
      ),
    );
  }
}
