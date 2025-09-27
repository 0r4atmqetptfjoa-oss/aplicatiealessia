import 'dart:math';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/profiles_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProfilesScreen extends StatelessWidget {
  const ProfilesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final svc = getIt<ProfilesService>();
    return Scaffold(
      appBar: AppBar(title: const Text('Profile copii')),
      body: ValueListenableBuilder<List<ChildProfile>>(
        valueListenable: svc.profiles,
        builder: (context, list, _) {
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final p = list[i];
                    final isActive = svc.active.value?.id == p.id;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(p.color),
                        child: const Icon(Icons.child_care, color: Colors.white),
                      ),
                      title: Text(p.name),
                      subtitle: Text(isActive ? 'Activ' : 'Tap pentru activare'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => svc.deleteProfile(p.id),
                      ),
                      onTap: () => svc.setActive(p.id),
                    ).animate().fade().slideX(begin: 0.1);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final rnd = Random();
                    final c = (0xFF000000 | (rnd.nextInt(0xFFFFFF)));
                    final id = DateTime.now().millisecondsSinceEpoch.toString();
                    final controller = TextEditingController(text: 'Copil nou');
                    await showDialog(context: context, builder: (_) {
                      return AlertDialog(
                        title: const Text('Nume profil'),
                        content: TextField(controller: controller, decoration: const InputDecoration(hintText: 'ex: Mara')), 
                        actions: [
                          TextButton(onPressed: ()=>Navigator.pop(context), child: const Text('Anulează')),
                          ElevatedButton(onPressed: () async {
                            await svc.addProfile(ChildProfile(id: id, name: controller.text.trim().isEmpty ? 'Copil' : controller.text.trim(), color: c));
                            if (context.mounted) Navigator.pop(context);
                          }, child: const Text('Adaugă')),
                        ],
                      );
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Adaugă profil'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
