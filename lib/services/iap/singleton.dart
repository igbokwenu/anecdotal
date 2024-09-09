import 'package:purchases_flutter/purchases_flutter.dart';

class AppData {
  static final AppData _appData = AppData._internal();

  bool? isPro = false;
  String appUserID = '';

  factory AppData() {
    return _appData;
  }
  AppData._internal();
}
CustomerInfo? customerInfo;
final appIAPStatus = AppData();