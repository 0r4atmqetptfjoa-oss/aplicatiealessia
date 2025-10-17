import 'package:flutter/material.dart';
import 'package:lumea_alessiei/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainMenuScreen extends ConsumerWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l10n.appTitle, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _MenuButton(label: l10n.menuSounds, onTap: () => context.go('/sounds')),
                    _MenuButton(label: l10n.menuInstruments, onTap: () => context.go('/instruments')),
                    _MenuButton(label: l10n.menuSongs, onTap: () => context.go('/songs')),
                    _MenuButton(label: l10n.menuStories, onTap: () => context.go('/stories')),
                    _MenuButton(label: l10n.menuGames, onTap: () => context.go('/games')),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: IconButton(
                icon: const Icon(Icons.settings, size: 40),
                onPressed: () => context.go('/parental-gate'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _MenuButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(label),
      ),
    );
  }
}
