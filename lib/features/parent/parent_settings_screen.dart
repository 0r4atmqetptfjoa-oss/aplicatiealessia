import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/parental_service.dart';
import 'package:alesia/services/theme_service.dart';
import 'package:alesia/services/analytics_service.dart';
import 'package:flutter/material.dart';

class ParentSettingsScreen extends StatefulWidget {
  const ParentSettingsScreen({super.key});

  @override
  State<ParentSettingsScreen> createState() => _ParentSettingsScreenState();
}

class _ParentSettingsScreenState extends State<ParentSettingsScreen> {
  final _pinCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final parental = getIt<ParentalService>();
    final theme = getIt<ThemeService>();
    final analytics = getIt<AnalyticsService>();
    return Scaffold(
      appBar: AppBar(title: const Text('Setări Părinți')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Schimbă PIN', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: TextField(controller: _pinCtrl, obscureText: true, maxLength: 4, decoration: const InputDecoration(border: OutlineInputBorder(), counterText: '', hintText: 'PIN nou'))),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: () async {
                await parental.setPin(_pinCtrl.text);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PIN actualizat')));
              }, child: const Text('Salvează')),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Temă sezonieră', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButton<Season>(
            value: theme.season,
            items: Season.values.map((s)=>DropdownMenuItem(value: s, child: Text(s.name))).toList(),
            onChanged: (s) async {
              if (s != null) await theme.setSeason(s);
              setState(()=>{});
            },
          ),
          const SizedBox(height: 24),
          const Text('Analitice locale', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pushNamed('/parinti/analytics'),
            child: const Text('Vezi evenimente'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () async { await analytics.clear(); setState(()=>{}); },
            child: const Text('Șterge toate evenimentele'),
          ),
          const SizedBox(height: 24),
          const Text('Resurse / TODO', style: TextStyle(fontWeight: FontWeight.bold)),
          const Text('Înlocuiește placeholder-ele din imagini/audio conform PROMPTS.md.'),
        ],
      ),
    );
  }
}
