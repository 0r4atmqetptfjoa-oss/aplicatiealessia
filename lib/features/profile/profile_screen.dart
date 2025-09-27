import 'dart:math';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/profile_service.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final svc = getIt<ProfileService>();
    final profiles = svc.profiles;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile copii')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final id = 'p${DateTime.now().millisecondsSinceEpoch}';
          final rnd = Random();
          final color = Colors.primaries[rnd.nextInt(Colors.primaries.length)].value;
          await svc.addProfile(ChildProfile(
            id: id,
            name: 'Copil',
            color: color,
            // TODO (Răzvan): Înlocuiește cu avatarul final
            avatarAsset: 'assets/images/placeholders/placeholder_square.png',
          ));
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, i) {
          final p = profiles[i];
          final isActive = svc.active.value?.id == p.id;
          return ListTile(
            onTap: () async { await svc.setActive(p.id); setState(()=>{}); },
            leading: CircleAvatar(
              radius: 24,
              // TODO (Răzvan): Avatar final pentru profil
              backgroundImage: AssetImage(p.avatarAsset),
            ),
            title: Text(p.name),
            subtitle: Text('Culoare: #${p.color.toRadixString(16).padLeft(8,'0')}'),
            trailing: isActive ? const Icon(Icons.check, color: Colors.green) : null,
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemCount: profiles.length,
      ),
    );
  }
}
