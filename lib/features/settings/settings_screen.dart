import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/settings_service.dart';

/// A screen that allows users to adjust app settings such as sound and music.
///
/// This screen uses [SettingsService] to store the state of each toggle.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>();
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Sound'),
            subtitle: const Text('Toggle game sound effects'),
            value: settings.soundOn,
            onChanged: (val) => context.read<SettingsService>().toggleSound(val),
          ),
          SwitchListTile(
            title: const Text('Music'),
            subtitle: const Text('Toggle background music'),
            value: settings.musicOn,
            onChanged: (val) => context.read<SettingsService>().toggleMusic(val),
          ),
          SwitchListTile(
            title: const Text('Hard Mode'),
            subtitle: const Text('Enable more challenging games'),
            value: settings.hardMode,
            onChanged: (val) => context.read<SettingsService>().toggleHardMode(val),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Additional settings can be added here such as language selection, '
              'difficulty levels, or parental controls.',
            ),
          ),
        ],
      ),
    );
  }
}