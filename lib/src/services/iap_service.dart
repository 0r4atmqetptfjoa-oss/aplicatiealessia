import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

const String _monthlySubscriptionId = 'monthly_subscription';
const String _yearlySubscriptionId = 'yearly_subscription';

class IAPService {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  IAPService() {
    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
  }

  Future<void> init() async {
    final bool available = await _iap.isAvailable();
    if (!available) {
      // The store cannot be reached or used
    }
  }

  Future<List<ProductDetails>> getProducts() async {
    final ProductDetailsResponse response = await _iap.queryProductDetails(
      Set<String>.from([_monthlySubscriptionId, _yearlySubscriptionId]),
    );
    if (response.error != null) {
      // handle error here.
      return [];
    }
    return response.productDetails;
  }

  Future<void> buySubscription(ProductDetails productDetails) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
    await _iap.buyConsumable(purchaseParam: purchaseParam);
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // show pending UI
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // handle error
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          // bool valid = await _verifyPurchase(purchaseDetails);
          // if (valid) {
          //   // deliver product
          // } else {
          //   // handle invalid purchase
          // }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _iap.completePurchase(purchaseDetails);
        }
      }
    });
  }

  void dispose() {
    _subscription.cancel();
  }
}

final iapServiceProvider = Provider<IAPService>((ref) {
  final iapService = IAPService();
  iapService.init();
  ref.onDispose(iapService.dispose);
  return iapService;
});
