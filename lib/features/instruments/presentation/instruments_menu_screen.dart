import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A simple menu screen that displays all available musical instruments.
///
/// Each instrument is represented by its icon and a label. Tapping on an
/// instrument will navigate to the corresponding game screen via the
/// configured routes in the app router. The layout uses a grid to display
/// the four instruments in a 2x2 arrangement with padding and spacing.
class InstrumentsMenuScreen extends StatelessWidget {
  const InstrumentsMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instrumente'),
        // Provide a back button to return to the home screen.
        leading: BackButton(
          onPressed: () => router.pop(),
        ),
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          padding: const EdgeInsets.all(32),
          children: [
            _InstrumentItem(
              imagePath: 'assets/images/piano.png',
              label: 'Pian',
              onTap: () => router.go('/instrumente/pian'),
            ),
            _InstrumentItem(
              imagePath: 'assets/images/drums.png',
              label: 'Tobe',
              onTap: () => router.go('/instrumente/tobe'),
            ),
            _InstrumentItem(
              imagePath: 'assets/images/xylophone.png',
              label: 'Xilofon',
              onTap: () => router.go('/instrumente/xilofon'),
            ),
            _InstrumentItem(
              imagePath: 'assets/images/organ.png',
              label: 'Orgă',
              onTap: () => router.go('/instrumente/orga'),
            ),
          ],
        ),
      ),
    );
  }
}

/// A reusable widget that displays an instrument icon and label. When tapped,
/// it will invoke the provided [onTap] callback. The icon is loaded from
/// local assets and scaled to fit within its container.
class _InstrumentItem extends StatelessWidget {
  const _InstrumentItem({
    required this.imagePath,
    required this.label,
    required this.onTap,
  });

  final String imagePath;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}