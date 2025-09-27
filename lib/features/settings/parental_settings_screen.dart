import 'package:alesia/services/parental_service.dart';
import 'package:alesia/services/seasonal_theme_service.dart';
import 'package:alesia/core/service_locator.dart';
import 'package:flutter/material.dart';

class ParentalSettingsScreen extends StatefulWidget {
  const ParentalSettingsScreen({super.key});

  @override
  State<ParentalSettingsScreen> createState() => _ParentalSettingsScreenState();
}

class _ParentalSettingsScreenState extends State<ParentalSettingsScreen> {
  final pinCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final season = getIt<SeasonalThemeService>();
    return Scaffold(
      appBar: AppBar(title: const Text('Setări Părinți')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('PIN Parental (opțional)', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(controller: pinCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'PIN (4 cifre)')),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              await getIt<ParentalService>().setPin(pinCtrl.text);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PIN salvat.')));
            },
            child: const Text('Salvează PIN'),
          ),
          const Divider(height: 32),
          const Text('Teme Sezoniere', style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8,
            children: SeasonTheme.values.map((s) {
              final label = s.toString().split('.').last;
              return ChoiceChip(
                label: Text(label),
                selected: season.mode.value == s,
                onSelected: (_) => setState(() => season.setSeason(s)),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Notă: Fundalurile parallax pot fi schimbate pentru fiecare sezon.'),
          const SizedBox(height: 8),
          const Text("// TODO (Răzvan): Adaugă imagini sezoniere în assets/images/final/: parallax_*_spring/summer/autumn/winter.png"),
        ],
      ),
    );
  }
}
