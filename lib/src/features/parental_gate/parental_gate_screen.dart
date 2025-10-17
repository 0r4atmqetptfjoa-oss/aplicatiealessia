import 'package:flutter/material.dart';

class ParentalGateScreen extends StatefulWidget {
  const ParentalGateScreen({super.key});

  @override
  State<ParentalGateScreen> createState() => _ParentalGateScreenState();
}

class _ParentalGateScreenState extends State<ParentalGateScreen> {
  bool _pressed = false;
  DateTime? _downAt;

  void _onPointerDown() {
    _pressed = true;
    _downAt = DateTime.now();
    setState(() {});
  }

  void _onPointerUp() {
    final heldMs = DateTime.now().difference(_downAt ?? DateTime.now()).inMilliseconds;
    _pressed = false;
    setState(() {});
    final ok = heldMs >= 1500; // hold 1.5s as simple gate
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? 'Unlocked' : 'Keep holding a bit longer')),
    );
    if (ok && mounted) {
      Navigator.of(context).maybePop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Listener(
          onPointerDown: (_) => _onPointerDown(),
          onPointerUp: (_) => _onPointerUp(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _pressed ? Colors.pink.shade200 : Colors.pink.shade100,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              'Ține apăsat 1.5s',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
      ),
    );
  }
}
