import 'dart:math';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/profile_service.dart';
import 'package:flutter/material.dart';

class ProfilesScreen extends StatefulWidget {
  const ProfilesScreen({super.key});

  @override
  State<ProfilesScreen> createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfilesScreen> {
  final ps = getIt<ProfileService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alege Profilul')),
      body: ValueListenableBuilder<List<ChildProfile>>(
        valueListenable: ps.profiles,
        builder: (context, profiles, _) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: profiles.length + 1,
            itemBuilder: (context, i) {
              if (i == profiles.length) {
                return Card(
                  child: InkWell(
                    onTap: () async {
                      final name = await _askName(context);
                      if (name == null || name.isEmpty) return;
                      final color = (Random().nextDouble() * 0xFFFFFF).toInt() | 0xFF000000;
                      await ps.addProfile(name, color);
                      // setState este apelat automat de ValueListenableBuilder
                    },
                    child: const Center(child: Icon(Icons.add, size: 48)),
                  ),
                );
              }
              final p = profiles[i];
              return ValueListenableBuilder<String?>(
                valueListenable: ps.activeId,
                builder: (context, activeId, _) {
                  final isActive = activeId == p.id;
                  return GestureDetector(
                    onTap: () => ps.setActive(p.id),
                    child: Card(
                      color: isActive ? Theme.of(context).primaryColorLight : null,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundColor: Color(p.color),
                            child: const Icon(Icons.child_care, color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<String?> _askName(BuildContext context) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nume nou'),
        content: TextField(controller: controller),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Anulează')),
          TextButton(onPressed: () => Navigator.of(context).pop(controller.text), child: const Text('OK')),
        ],
      ),
    );
  }
}