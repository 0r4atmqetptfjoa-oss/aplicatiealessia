import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/parental_service.dart';
import 'package:flutter/material.dart';

Future<bool> showParentGate(BuildContext context) async {
  final controller = TextEditingController();
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Acces părinți'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Introdu PIN-ul de 4 cifre'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              obscureText: true,
              maxLength: 4,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(border: OutlineInputBorder(), counterText: ''),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: ()=>Navigator.pop(context, false), child: const Text('Anulează')),
          ElevatedButton(onPressed: (){
            final ok = getIt<ParentalService>().verify(controller.text);
            Navigator.pop(context, ok);
          }, child: const Text('OK')),
        ],
      );
    }
  );
  return ok ?? false;
}
