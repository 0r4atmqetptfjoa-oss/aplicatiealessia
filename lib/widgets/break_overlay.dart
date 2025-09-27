import 'package:flutter/material.dart';

class BreakOverlay extends StatelessWidget {
  final ValueListenable<bool> flag;
  final VoidCallback onDismiss;
  const BreakOverlay({super.key, required this.flag, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: flag,
      builder: (context, show, _) {
        if (!show) return const SizedBox.shrink();
        return SafeArea(
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Material(
                color: Colors.amber.shade100,
                elevation: 6,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_cafe),
                      const SizedBox(width: 8),
                      const Text('Timp de pauză! Ridică-te, întinde-te, respiră 😊'),
                      const SizedBox(width: 8),
                      ElevatedButton(onPressed: onDismiss, child: const Text('OK')),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
