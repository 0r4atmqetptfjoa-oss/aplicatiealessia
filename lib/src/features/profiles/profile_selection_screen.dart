import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/user_profile.dart';
import '../../services/user_profile_service.dart';
import '../../core/router/app_router.dart'; // Import the router provider

class ProfileSelectionScreen extends ConsumerWidget {
  const ProfileSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilesFuture = ref.watch(profilesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Select Profile')),
      body: profilesFuture.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (profiles) {
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
                return const _AddProfileButton();
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
        ref.invalidate(appRouterProvider); // Invalidate to trigger router refresh
        if (context.mounted) {
          context.go('/home');
        }
      },
      child: Card(
        color: profile.themeColor.withAlpha(200),
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
  const _AddProfileButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
      ref.invalidate(profilesProvider); // Use invalidate to refresh the list
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
