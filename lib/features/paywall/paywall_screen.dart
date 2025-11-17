import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/subscription_service.dart';

/// A placeholder screen for the paywall.
///
/// In a real app this screen could present subscription options, in-app
/// purchases or information about premium content. For now it simply
/// explains that the paywall feature will be implemented later.
class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unlock More Fun')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'You have reached the free content limit. Upgrade to unlock '
                'all games and features!',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Simulate a one‑time purchase of 19.99 lei.
                  context.read<SubscriptionService>().purchasePremium();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Thank you for your purchase! Premium content unlocked.',
                      ),
                    ),
                  );
                  // Navigate back to the main menu or previous screen
                  context.go('/');
                },
                child: const Text('Unlock full version – 19.99 lei'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}