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
    return Scaffold(
      appBar: AppBar(title: const Text('Profiluri Copii')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final nameCtrl = TextEditingController();
          final rnd = Random();
          final color = Colors.primaries[rnd.nextInt(Colors.primaries.length)].value;
          final ok = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Profil nou'),
              content: TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nume')),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Anulează')),
                TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Creează')),
              ],
            ),
          );
          if (ok == true && nameCtrl.text.trim().isNotEmpty) {
            await svc.addProfile(nameCtrl.text.trim(), color);
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Alege profilul activ:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...svc.profiles.map((p) => ListTile(
                leading: CircleAvatar(backgroundColor: Color(p.color)),
                title: Text(p.name),
                trailing: svc.active.value?.id == p.id ? const Icon(Icons.check_circle, color: Colors.green) : null,
                onTap: () async {
                  await svc.setActive(p.id);
                  setState(() {});
                },
              )),
        ],
      ),
    );
  }
}
