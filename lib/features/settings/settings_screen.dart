import 'package:alesia/core/service_locator.dart';
import 'package:alesia/features/settings/parental_gate.dart';
import 'package:alesia/services/parental_service.dart';
import 'package:alesia/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeService>();
    final parental = getIt<ParentalService>();
    return Scaffold(
      appBar: AppBar(title: const Text('Setări & Control Parental')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Temă sezonieră', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: SeasonTheme.values.map((s) {
              return ChoiceChip(
                label: Text(s.name),
                selected: theme.current == s,
                onSelected: (_) => theme.setTheme(s),
              ).animate().fadeIn();
            }).toList(),
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.lock),
            title: Text(parental.hasPin ? 'Schimbă PIN parental' : 'Setează PIN parental'),
            onTap: () async {
              final ok = await showParentalGate(context);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'PIN actualizat/verificat' : 'Anulat')));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Analitice (doar părinți)'),
            onTap: () async {
              final ok = await showParentalGate(context);
              if (ok && context.mounted) context.push('/analitice');
            },
          ),
          ListTile(
            leading: const Icon(Icons.emoji_events),
            title: const Text('Misiuni & Recompense'),
            onTap: () => context.push('/misiuni'),
          ),
        ],
      ),
    );
  }
}
