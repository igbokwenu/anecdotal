import 'package:anecdotal/services/iap/singleton.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final iapProvider = StateNotifierProvider<IAPNotifier, IAPState>((ref) {
  return IAPNotifier();
});
