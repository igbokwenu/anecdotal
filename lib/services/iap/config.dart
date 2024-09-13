import 'dart:io';

import 'package:anecdotal/services/iap/store_config.dart';
import 'package:anecdotal/utils/constants/constants.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

Future<void> configureRevenueCatSDK() async {
  // Enable debug logs before calling `configure`.
  await Purchases.setLogLevel(LogLevel.debug);

  /*
    - appUserID is null, so an anonymous ID will be generated automatically by the Purchases SDK. Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids

    - purchasesAreCompletedBy is PurchasesAreCompletedByMyApp, meaning your app will handle finishing transactions.
    */
  PurchasesConfiguration configuration;
  if (StoreConfig.isForAmazonAppstore()) {
    configuration = AmazonConfiguration(StoreConfig.instance.apiKey)
      ..appUserID = null
      ..purchasesAreCompletedBy = PurchasesAreCompletedByMyApp(
        storeKitVersion: StoreKitVersion.storeKit2,
      );
  } else {
    configuration = PurchasesConfiguration(StoreConfig.instance.apiKey)
      ..appUserID = null
      ..purchasesAreCompletedBy = PurchasesAreCompletedByMyApp(
        storeKitVersion: StoreKitVersion.storeKit2,
      );
  }
  await Purchases.configure(configuration);
}

Future<void> initializeRevenueCat() async {
    if (Platform.isIOS || Platform.isMacOS) {
    StoreConfig(
      store: Store.appStore,
      apiKey: appleApiKey,
    );
  } else if (Platform.isAndroid) {
    // Run the app passing --dart-define=AMAZON=true
    const useAmazon = bool.fromEnvironment("amazon");
    StoreConfig(
      store: useAmazon ? Store.amazon : Store.playStore,
      apiKey: useAmazon ? amazonApiKey : googleApiKey,
    );
  }

}
