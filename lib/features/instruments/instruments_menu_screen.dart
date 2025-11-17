import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Menu screen listing all instrument activities.
///
/// This screen displays a list of available instruments. Each entry shows
/// a custom icon loaded from the assets directory and navigates to the
/// corresponding instrument play screen when tapped. New instruments can be
/// added by expanding the list and defining the appropriate route in
/// [AppRouter].
class InstrumentsMenuScreen extends StatelessWidget {
  const InstrumentsMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Instruments')),
      body: ListView(
        children: const [
          _InstrumentTile(
            title: 'Piano',
            path: 'piano',
            assetName: 'piano.png',
          ),
          _InstrumentTile(
            title: 'Drums',
            path: 'drums',
            assetName: 'drums.png',
          ),
          _InstrumentTile(
            title: 'Xylophone',
            path: 'xylophone',
            assetName: 'xylophone.png',
          ),
        ],
      ),
    );
  }
}

class _InstrumentTile extends StatelessWidget {
  final String title;
  final String path;
  final String assetName;

  const _InstrumentTile({
    required this.title,
    required this.path,
    required this.assetName,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        'assets/images/$assetName',
        width: 40,
        height: 40,
      ),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () => context.go('/instruments/$path'),
    );
  }
}