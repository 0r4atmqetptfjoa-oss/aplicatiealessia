import 'package:flutter_riverpod/flutter_riverpod.dart';

// In a real app, this would check against a backend or the device's IAP status.
// For now, we use a simple boolean to simulate a subscription.

class SubscriptionService {
  // For demonstration, we'll start with the user unsubscribed.
  bool _isSubscribed = false;

  bool get isSubscribed => _isSubscribed;

  void subscribe() {
    _isSubscribed = true;
  }

  void unsubscribe() {
    _isSubscribed = false;
  }
}

final subscriptionServiceProvider = Provider<SubscriptionService>((ref) {
  return SubscriptionService();
});
