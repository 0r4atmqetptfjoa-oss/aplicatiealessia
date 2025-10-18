import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/user_profile.dart';
import '../../services/user_profile_service.dart';

class ProfileSelectionScreen extends ConsumerWidget {
  const ProfileSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilesFuture = ref.watch(userProfileServiceProvider).getProfiles();

    return Scaffold(
      appBar: AppBar(title: const Text('Select Profile')),
      body: FutureBuilder<List<UserProfile>>(
        future: profilesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final profiles = snapshot.data ?? [];

          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
            ),
            itemCount: profiles.length + 1, // +1 for the 'Add Profile' button
            itemBuilder: (context, index) {
              if (index == profiles.length) {
                return _AddProfileButton();
              }
              final profile = profiles[index];
              return _ProfileCard(profile: profile);
            },
          );
        },
      ),
    );
  }
}

class _ProfileCard extends ConsumerWidget {
  final UserProfile profile;
  const _ProfileCard({required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        final service = ref.read(userProfileServiceProvider);
        await service.setActiveProfile(profile.id);
        context.go('/home');
      },
      child: Card(
        color: profile.themeColor.withOpacity(0.8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 60, color: Colors.white),
            const SizedBox(height: 12),
            Text(profile.name, style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _AddProfileButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to a create profile screen or show a dialog
        showDialog(
          context: context,
          builder: (context) => const _CreateProfileDialog(),
        );
      },
      child: Card(
        color: Colors.grey.shade300,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 60, color: Colors.white),
            SizedBox(height: 12),
            Text('Add Profile', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _CreateProfileDialog extends ConsumerStatefulWidget {
  const _CreateProfileDialog();

  @override
  ConsumerState<_CreateProfileDialog> createState() => _CreateProfileDialogState();
}

class _CreateProfileDialogState extends ConsumerState<_CreateProfileDialog> {
  final _textController = TextEditingController();

  void _createProfile() async {
    if (_textController.text.isNotEmpty) {
      final service = ref.read(userProfileServiceProvider);
      await service.createNewProfile(_textController.text);
      // Refresh the profiles list by invalidating the provider
      ref.refresh(userProfileServiceProvider);
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Profile'),
      content: TextField(
        controller: _textController,
        decoration: const InputDecoration(hintText: "Enter profile name"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _createProfile,
          child: const Text('Create'),
        ),
      ],
    );
  }
}
