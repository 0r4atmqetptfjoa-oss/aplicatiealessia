import 'package:flutter/foundation.dart';

/// A simple subscription service used to gate premium content.
///
/// In a production app you would integrate the [`in_app_purchase` package]
/// and verify purchases with the Play Store/App Store. The official Flutter
/// codelab notes that in‑app purchases require correctly setting up store
/// configurations and verifying purchases before granting access【821762457402857†L174-L198】.
/// For our demo, this service simply exposes a boolean flag that indicates
/// whether the user has unlocked the premium content. A one‑time purchase
/// (non‑consumable) is simulated by setting this flag to true. The
/// codelab explains that non‑consumable purchases only need to be bought
/// once and remain available forever【821762457402857†L188-L195】.
class SubscriptionService extends ChangeNotifier {
  bool _isPremium = false;

  /// Whether the user has purchased the premium upgrade.
  bool get isPremium => _isPremium;

  /// Simulate a one‑time purchase of the premium version.
  ///
  /// In a real app this would trigger the billing flow using
  /// `InAppPurchase.instance.buyNonConsumable()`. Once the purchase is
  /// successfully verified, call this method to unlock all content.
  void purchasePremium() {
    _isPremium = true;
    notifyListeners();
  }
}