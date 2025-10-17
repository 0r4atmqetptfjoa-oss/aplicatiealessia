import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ParentalGateScreen extends StatefulWidget {
  const ParentalGateScreen({super.key});

  @override
  State<ParentalGateScreen> createState() => _ParentalGateScreenState();
}

class _ParentalGateScreenState extends State<ParentalGateScreen> {
  Timer? _timer;
  int _holdDuration = 0;
  final int _requiredHoldTime = 3; // seconds

  void _onPointerDown(PointerDownEvent details) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _holdDuration++;
      });
      if (_holdDuration >= _requiredHoldTime) {
        _timer?.cancel();
        // Navigate to settings or a placeholder
        context.go('/home'); 
      }
    });
  }

  void _onPointerUp(PointerUpEvent details) {
    _timer?.cancel();
    setState(() {
      _holdDuration = 0;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Control Parental')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Pentru a continua, ține apăsat butonul.',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onPointerDown: _onPointerDown,
                onPointerUp: _onPointerUp,
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: CircularProgressIndicator(
                          value: _holdDuration / _requiredHoldTime,
                          strokeWidth: 10,
                          backgroundColor: Colors.grey.shade300,
                        ),
                      ),
                      const Icon(Icons.touch_app, size: 80, color: Colors.blue),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '${_requiredHoldTime - _holdDuration} secunde rămase',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
