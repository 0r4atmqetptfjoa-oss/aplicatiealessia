import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class ProfileSelectScreen extends StatefulWidget {
  const ProfileSelectScreen({super.key});

  @override
  State<ProfileSelectScreen> createState() => _ProfileSelectScreenState();
}

class _ProfileSelectScreenState extends State<ProfileSelectScreen> {
  @override
  Widget build(BuildContext context) {
    final svc = getIt<ProfileService>();
    return Scaffold(
      appBar: AppBar(title: const Text('Alege un profil')),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16),
              itemCount: svc.profiles.length + 1,
              itemBuilder: (context, i) {
                if (i == svc.profiles.length) {
                  return _AddCard(onTap: () async {
                    await context.push('/profil/edit');
                    setState(() {});
                  });
                }
                final p = svc.profiles[i];
                return GestureDetector(
                  onTap: () async {
                    await svc.select(p.id);
                    if (context.mounted) context.go('/');
                  },
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // TODO (Răzvan): Înlocuiește cu avatar-ul final corespunzător p.avatar (ex: 'avatar_1.png')
                        Image.asset('assets/images/placeholders/placeholder_square.png', width: 100, height: 100),
                        const SizedBox(height: 8),
                        Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ).animate().fade().scale();
              },
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _AddCard extends StatelessWidget {
  final VoidCallback onTap;
  const _AddCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: DottedBorderCard(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add, size: 40),
            SizedBox(height: 8),
            Text('Profil nou'),
          ],
        ),
      ),
    );
  }
}

class DottedBorderCard extends StatelessWidget {
  final Widget child;
  const DottedBorderCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.black26, width: 2, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
