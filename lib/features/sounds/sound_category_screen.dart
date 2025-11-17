import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Displays details of a specific sound category.
class SoundCategoryScreen extends StatelessWidget {
  const SoundCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sound Category')),
      body: ListView(
        children: const [
          _SoundTile(title: 'Sound A'),
          _SoundTile(title: 'Sound B'),
          _SoundTile(title: 'Sound C'),
        ],
      ),
    );
  }
}

class _SoundTile extends StatelessWidget {
  final String title;
  const _SoundTile({required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.play_arrow),
      onTap: () => context.go('/sounds/detail'),
    );
  }
}