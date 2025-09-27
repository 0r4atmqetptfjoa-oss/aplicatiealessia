import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/parents_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class ParentalGateScreen extends StatefulWidget {
  const ParentalGateScreen({super.key});

  @override
  State<ParentalGateScreen> createState() => _ParentalGateScreenState();
}

class _ParentalGateScreenState extends State<ParentalGateScreen> {
  final _pinController = TextEditingController();
  String _error = '';

  Future<void> _submit() async {
    final target = await getIt<ParentsService>().getPin();
    if (_pinController.text == target) {
      if (!mounted) return;
      context.go('/parinti/panou');
    } else {
      setState(() => _error = 'Pin incorect. Încearcă din nou.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Control Parental')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Introdu PIN-ul de părinte', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _pinController,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    decoration: const InputDecoration(counterText: '', border: OutlineInputBorder(), hintText: '****'),
                    onSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 8),
                  if (_error.isNotEmpty) Text(_error, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                  ElevatedButton(onPressed: _submit, child: const Text('Intră în panou')),
                ],
              ),
            ),
          ).animate().fade().scale(),
        ),
      ),
    );
  }
}
