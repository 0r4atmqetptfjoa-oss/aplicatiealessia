import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/parental_service.dart';
import 'package:flutter/material.dart';

Future<bool> showParentalGate(BuildContext context) async {
  final parental = getIt<ParentalService>();
  String pin = '';
  String pinConfirm = '';
  bool creating = !parental.hasPin;
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: Text(creating ? 'Setează PIN' : 'Introduce PIN'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                decoration: const InputDecoration(labelText: 'PIN (4 cifre)'),
                onChanged: (v) => pin = v,
              ),
              if (creating)
                TextField(
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 4,
                  decoration: const InputDecoration(labelText: 'Confirmă PIN'),
                  onChanged: (v) => pinConfirm = v,
                ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Renunță')),
            ElevatedButton(
              onPressed: () async {
                if (creating) {
                  if (pin.length == 4 && pin == pinConfirm) {
                    await parental.setPin(pin);
                    // success, now ask once to verify
                    Navigator.pop(context, true);
                  }
                } else {
                  final ok = await parental.verifyPin(pin);
                  if (ok) Navigator.pop(context, true);
                }
              },
              child: Text(creating ? 'Setează' : 'Confirmă'),
            ),
          ],
        );
      });
    },
  ) ?? false;
}
