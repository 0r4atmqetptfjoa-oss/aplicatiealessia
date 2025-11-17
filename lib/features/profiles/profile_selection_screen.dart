import 'package:flutter/material.dart';

/// A placeholder screen for selecting a user profile.
///
/// Apps geared toward children often support multiple profiles so each
/// child can track their progress independently. This screen would
/// eventually allow users to add, edit and select profiles. Currently it
/// lists a few sample profiles and shows a snack bar when one is tapped.
class ProfileSelectionScreen extends StatelessWidget {
  const ProfileSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profiles = ['Alex', 'Bianca', 'Chris'];
    return Scaffold(
      appBar: AppBar(title: const Text('Select Profile')),
      body: ListView.builder(
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          final name = profiles[index];
          return ListTile(
            leading: Image.asset(
              'assets/images/profile_selection.png',
              width: 40,
              height: 40,
            ),
            title: Text(name),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Profile $name selected (feature pending).')),
              );
            },
          );
        },
      ),
    );
  }
}