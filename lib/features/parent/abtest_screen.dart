import 'package:flutter/material.dart';
import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/ab_service.dart';

class ABTestScreen extends StatefulWidget {
  const ABTestScreen({super.key});

  @override
  State<ABTestScreen> createState() => _ABTestScreenState();
}

class _ABTestScreenState extends State<ABTestScreen> {
  late ABService ab;

  @override
  void initState() {
    super.initState();
    ab = getIt<ABService>();
  }

  @override
  Widget build(BuildContext context) {
    final home = ab.variant('home_bounce');
    return ListView(
      children: [
        const ListTile(title: Text('Experiment: Home Bounce')),
        RadioListTile<String>(
          value: 'A', groupValue: home,
          onChanged: (v) async { await ab.setVariant('home_bounce', v!); setState(() {}); },
          title: const Text('A — bounce subtil'),
        ),
        RadioListTile<String>(
          value: 'B', groupValue: home,
          onChanged: (v) async { await ab.setVariant('home_bounce', v!); setState(() {}); },
          title: const Text('B — bounce pronunțat'),
        ),
      ],
    );
  }
}
