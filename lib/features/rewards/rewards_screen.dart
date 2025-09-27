import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  late ProfileService _profile;

  @override
  void initState() {
    super.initState();
    _profile = getIt<ProfileService>();
  }

  @override
  Widget build(BuildContext context) {
    final stickers = _profile.stickers;
    return Scaffold(
      appBar: AppBar(title: const Text('Colecția de Stickere')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 8),
                Text('Stele: ${_profile.stars}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ).animate().fadeIn(),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: stickers.length,
                itemBuilder: (context, i) {
                  final unlocked = stickers[i];
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                      border: Border.all(color: unlocked ? Colors.amber : Colors.grey.shade300, width: unlocked ? 3 : 1),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Image.asset(
                            // TODO (Răzvan): Înlocuiește cu imaginea sticker-ului final (ex: assets/images/final/sticker_XX.png)
                            'assets/images/placeholders/placeholder_square.png',
                            fit: BoxFit.contain, width: 80, height: 80,
                          ),
                        ),
                        if (!unlocked)
                          const Positioned.fill(
                            child: Center(child: Icon(Icons.lock_outline, size: 28, color: Colors.black54)),
                          ),
                      ],
                    ),
                  ).animate().scale(delay: (i * 30).ms).fadeIn();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
