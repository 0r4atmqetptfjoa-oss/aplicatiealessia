import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/profile_service.dart';
import 'package:flutter/material.dart';

class ProfileDashboardScreen extends StatelessWidget {
  const ProfileDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prof = getIt<ProfileService>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilul Meu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder<String?>(
          valueListenable: prof.activeId,
          builder: (context, activeId, _) {
            final activeProfile = prof.active;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profil activ: ${activeProfile?.name ?? '-'}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // Adaugă aici mai multe widget-uri pentru a afișa datele
              ],
            );
          },
        ),
      ),
    );
  }
}