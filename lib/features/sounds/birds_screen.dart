import 'package:flutter/material.dart';

/// A placeholder screen for the birds sound category.
///
/// This screen could list different bird species and play corresponding
/// chirping sounds when tapped. At the moment it displays a simple
/// description explaining its future purpose.
class BirdsScreen extends StatelessWidget {
  const BirdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Birds')),
      body: const Center(
        child: Text('Bird sounds will be implemented here.'),
      ),
    );
  }
}