import 'package:anecdotal/utils/constants/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IAPState {
  final bool isPro;
  const IAPState({this.isPro = false});
}

class IAPNotifier extends StateNotifier<IAPState> {
  DateTime? _lastChecked;

  IAPNotifier() : super(const IAPState());

  Future<void> checkAndSetIAPStatus() async {
    // Only check if the user is not a pro user (i.e., doesn't have a subscription)
    if (state.isPro) {
      return; // Skip checking if the user already has a subscription
    }

    // Throttle the check to only happen every 30 seconds
    if (_lastChecked != null &&
        DateTime.now().difference(_lastChecked!).inSeconds < 30) {
      return;
    }
    _lastChecked = DateTime.now(); // Update the last checked time

    try {
      final CustomerInfo purchaserInfo = await Purchases.getCustomerInfo();
      bool isProUser =
          purchaserInfo.entitlements.all[entitlementID]?.isActive ?? false;
      state = IAPState(isPro: isProUser);
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }
}

// class AppData {
//   static final AppData _appData = AppData._internal();

//   bool? isPro = false;
//   String appUserID = '';

//   factory AppData() {
//     return _appData;
//   }
//   AppData._internal();
// }

// CustomerInfo? customerInfo;
// final appIAPStatus = AppData();

// class RevenueCatService {
//   //This code checks if the user is a pro user. if user is pro, it sets the appIAPStatus to true
//   static Future<void> checkAndSetIAPStatus() async {
//     CustomerInfo purchaserInfo;
//     try {
//       purchaserInfo = await Purchases.getCustomerInfo();
//       if (kDebugMode) {
//         debugPrint('Yo, check this out:\n ${purchaserInfo.toString()}');
//       }

//       if (purchaserInfo.entitlements.all[entitlementID] != null) {
//         appIAPStatus.isPro =
//             purchaserInfo.entitlements.all[entitlementID]?.isActive;
//       } else {
//         appIAPStatus.isPro = false;
//       }
//     } on PlatformException catch (e) {
//       debugPrint(e.toString());
//     }

//     debugPrint('#### is user pro? ${appIAPStatus.isPro}');
//   }
// }
