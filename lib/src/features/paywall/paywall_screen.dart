import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/subscription_service.dart';

class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Unlock Full Access', // Placeholder - will be localized
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Get unlimited access to all songs, stories, and games!', // Placeholder
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 48),
                _SubscriptionOption(
                  title: 'Yearly', // Placeholder
                  price: '\$29.99/year', // Placeholder
                  isBestValue: true,
                  onTap: () {
                    ref.read(subscriptionServiceProvider).subscribe();
                    context.go('/home');
                  },
                ),
                const SizedBox(height: 16),
                _SubscriptionOption(
                  title: 'Monthly', // Placeholder
                  price: '\$4.99/month', // Placeholder
                  onTap: () {
                    ref.read(subscriptionServiceProvider).subscribe();
                    context.go('/home');
                  },
                ),
                const SizedBox(height: 48),
                TextButton(
                  onPressed: () {
                    ref.read(subscriptionServiceProvider).subscribe();
                    context.go('/home');
                  },
                  child: const Text('Restore Purchases'), // Placeholder
                ),
                const SizedBox(height: 16),
                IconButton(
                  icon: const Icon(Icons.close, size: 40),
                  onPressed: () => context.pop(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SubscriptionOption extends StatelessWidget {
  final String title;
  final String price;
  final bool isBestValue;
  final VoidCallback onTap;

  const _SubscriptionOption({
    required this.title,
    required this.price,
    this.isBestValue = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border.all(color: isBestValue ? Colors.amber : Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(16),
          color: isBestValue ? Colors.amber.withOpacity(0.1) : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(price, style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
