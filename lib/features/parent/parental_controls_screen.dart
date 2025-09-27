import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/parental_control_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ParentalControlsScreen extends StatefulWidget {
  const ParentalControlsScreen({super.key});

  @override
  State<ParentalControlsScreen> createState() => _ParentalControlsScreenState();
}

class _ParentalControlsScreenState extends State<ParentalControlsScreen> {
  late ParentalControlService s;

  @override
  void initState() {
    super.initState();
    s = getIt<ParentalControlService>();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _pinTile(context),
        const Divider(),
        SwitchListTile(
          value: s.bgMusicEnabled,
          onChanged: (v) => setState(() {
            s.bgMusicEnabled = v;
            s.save();
          }),
          title: const Text('Muzică de fundal'),
          subtitle: const Text('Pornește/oprește muzica de fundal (dacă este disponibilă)'),
        ).animate().fadeIn(),
        SwitchListTile(
          value: s.disableParticles,
          onChanged: (v) => setState(() {
            s.disableParticles = v;
            s.save();
          }),
          title: const Text('Dezactivează particulele'),
          subtitle: const Text('Efectele vizuale „confetti” sunt dezactivate când este ON'),
        ).animate().fadeIn(delay: 100.ms),
        const SizedBox(height: 12),
        ListTile(
          title: const Text('Limită zilnică (minute)'),
          subtitle: const Text('0 = nelimitat'),
          trailing: SizedBox(
            width: 100,
            child: TextFormField(
              initialValue: s.dailyMinutes.toString(),
              keyboardType: TextInputType.number,
              onFieldSubmitted: (v) {
                final val = int.tryParse(v) ?? 0;
                setState(() {
                  s.dailyMinutes = val;
                  s.save();
                });
              },
            ),
          ),
        ).animate().fadeIn(delay: 200.ms),
      ],
    );
  }

  Widget _pinTile(BuildContext context) {
    final hasPin = s.parentPin.isNotEmpty;
    return ListTile(
      title: Text(hasPin ? 'Schimbă PIN' : 'Setează PIN (4 cifre)'),
      subtitle: Text(hasPin ? 'PIN existent. Apasă pentru a-l schimba/șterge.' : 'Protejează accesul la Zona Părinți.'),
      trailing: const Icon(Icons.pin),
      onTap: () async {
        final result = await showDialog<_PinAction>(
          context: context,
          builder: (ctx) => _PinDialog(hasPin: hasPin),
        );
        if (result == null) return;
        if (result == _PinAction.remove) {
          setState(() {
            s.parentPin = '';
            s.save();
          });
        } else if (result == _PinAction.set) {
          final pin = await showDialog<String?>(
            context: context,
            builder: (ctx) => const _EnterPinDialog(),
          );
          if (pin != null && pin.length == 4) {
            setState(() {
              s.parentPin = pin; // DEMO: în producție folosește hashing
              s.save();
            });
          }
        }
      },
    );
  }
}

enum _PinAction { set, remove }

class _PinDialog extends StatelessWidget {
  final bool hasPin;
  const _PinDialog({required this.hasPin});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('PIN părinte'),
      content: Text(hasPin ? 'Vrei să schimbi sau să ștergi PIN-ul?' : 'Setează un PIN nou.'),
      actions: [
        if (hasPin) TextButton(onPressed: () => Navigator.pop(context, _PinAction.remove), child: const Text('Șterge PIN')),
        ElevatedButton(onPressed: () => Navigator.pop(context, _PinAction.set), child: Text(hasPin ? 'Schimbă PIN' : 'Setează PIN')),
      ],
    );
  }
}

class _EnterPinDialog extends StatefulWidget {
  const _EnterPinDialog();

  @override
  State<_EnterPinDialog> createState() => _EnterPinDialogState();
}

class _EnterPinDialogState extends State<_EnterPinDialog> {
  final c = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Introdu PIN (4 cifre)'),
      content: TextField(controller: c, keyboardType: TextInputType.number, maxLength: 4, obscureText: true),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Anulează')),
        ElevatedButton(onPressed: () => Navigator.pop(context, c.text.trim()), child: const Text('OK')),
      ],
    );
  }
}