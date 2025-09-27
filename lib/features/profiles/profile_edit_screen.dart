import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/profile_service.dart';
import 'package:flutter/material.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _name = TextEditingController();
  String _avatar = 'avatar_1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil nou')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nume copil', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(controller: _name, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'ex: Ana')),
            const SizedBox(height: 16),
            const Text('Alege avatar', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(6, (i) {
                final id = 'avatar_${i+1}';
                final selected = _avatar == id;
                return GestureDetector(
                  onTap: () => setState(() => _avatar = id),
                  child: Stack(
                    children: [
                      // TODO (Răzvan): Înlocuiește cu avatar final id+'.png'
                      Image.asset('assets/images/placeholders/placeholder_square.png', width: 72, height: 72),
                      if (selected)
                        const Positioned(right: 4, bottom: 4, child: Icon(Icons.check_circle, color: Colors.green)),
                    ],
                  ),
                );
              }),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_name.text.trim().isEmpty) return;
                  await getIt<ProfileService>().createAndSelect(_name.text.trim(), _avatar);
                  if (mounted) Navigator.pop(context);
                },
                child: const Text('Salvează'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
