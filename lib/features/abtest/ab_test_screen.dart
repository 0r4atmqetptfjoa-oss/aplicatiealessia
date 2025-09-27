import 'package:alesia/core/service_locator.dart';
import 'package:alesia/services/ab_test_service.dart';
import 'package:alesia/services/profile_service.dart';
import 'package:flutter/material.dart';

class ABTestScreen extends StatefulWidget {
  const ABTestScreen({super.key});

  @override
  State<ABTestScreen> createState() => _ABTestScreenState();
}

class _ABTestScreenState extends State<ABTestScreen> {
  late ABTestService ab;
  late ProfileService ps;
  @override
  void initState() {
    super.initState();
    ab = getIt<ABTestService>();
    ps = getIt<ProfileService>();
    ab.assignDeterministic('press_scale', ps.activeId.value ?? 'p1');
  }

  @override
  Widget build(BuildContext context) {
    final variant = ab.variantOf('press_scale');
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Testare ghidată (on-device)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ListTile(
          title: const Text('Experiment: Press Scale'),
          subtitle: const Text('Cât de mult se "apasă" pad-urile la tap'),
          trailing: DropdownButton<String>(
            value: variant,
            items: const [
              DropdownMenuItem(value: 'A', child: Text('A (0.92)')),
              DropdownMenuItem(value: 'B', child: Text('B (0.86)')),
            ],
            onChanged: (v) async {
              if (v == null) return;
              await ab.setVariant('press_scale', v);
              if (mounted) setState(() {});
            },
          ),
        ),
        const SizedBox(height: 12),
        Text('Variantă actuală pentru profilul activ (${ps.activeId.value}): $variant'),
        const SizedBox(height: 24),
        const Text('Notă: fără rețea. Persistă local în SharedPreferences.', style: TextStyle(color: Colors.black54)),
      ],
    );
  }
}
