import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParentalService {
  static const _kPin = 'parent_pin';
  String? _pin;

  Future<void> init() async {
    final p = await SharedPreferences.getInstance();
    _pin = p.getString(_kPin);
  }

  Future<void> setPin(String pin) async {
    final p = await SharedPreferences.getInstance();
    _pin = pin;
    await p.setString(_kPin, pin);
  }

  Future<bool> verifyPin(String pin) async => _pin == null || _pin == pin;

  Future<bool> parentalGate(BuildContext context) async {
    final rnd = Random();
    final a = 10 + rnd.nextInt(40);
    final b = 10 + rnd.nextInt(40);
    final controller = TextEditingController();
    final pinController = TextEditingController();
    bool solved = false;
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Acces Părinți'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Ține apăsat butonul 2 secunde și rezolvă exercițiul.'),
              const SizedBox(height: 8),
              Text('Cât face $a + $b ?'),
              TextField(controller: controller, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Răspuns')),
              const SizedBox(height: 8),
              if (_pin != null) TextField(controller: pinController, obscureText: true, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'PIN (4 cifre)')),
            ],
          ),
          actions: [
            GestureDetector(
              onLongPress: () { solved = true; },
              child: TextButton(onPressed: null, child: const Text('Ține apăsat 2s')),
            ),
            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Anulează')),
            TextButton(onPressed: () {
              final okMath = int.tryParse(controller.text) == a + b;
              final okPin = _pin == null || pinController.text == _pin;
              Navigator.of(ctx).pop(solved && okMath && okPin);
            }, child: const Text('Continuă')),
          ],
        );
      },
    );
    return ok ?? false;
  }
}
