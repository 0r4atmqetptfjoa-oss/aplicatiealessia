import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InstrumentsMenuScreen extends StatelessWidget {
  const InstrumentsMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instrumente Muzicale'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInstrumentButton(
                context,
                icon: Icons.piano,
                label: 'Pian',
                onTap: () => context.go('/instruments/piano'),
              ),
              _buildInstrumentButton(
                context,
                icon: Icons.music_video, // Pictogramă corectată
                label: 'Tobe',
                onTap: () => context.go('/instruments/drums'),
              ),
              _buildInstrumentButton(
                context,
                icon: Icons.music_note,
                label: 'Xilofon',
                onTap: () => context.go('/instruments/xylophone'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstrumentButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 100, color: Colors.white),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
