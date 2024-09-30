import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_review/in_app_review.dart';

class EventCountNotifier extends StateNotifier<int> {
  EventCountNotifier() : super(0) {
    _loadEventCount();
  }

  final InAppReview _inAppReview = InAppReview.instance;

  Future<void> _loadEventCount() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getInt('eventCount') ?? 0;
  }

  Future<void> _saveEventCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('eventCount', state);
  }

  Future<void> incrementEventCount() async {
    state++;
    await _saveEventCount();
    await _checkAndRequestReview();
  }

  Future<void> _checkAndRequestReview() async {
    if (kDebugMode) {
      print('In App Review Event Count Is $state');
    }
    if (state == 5 || state == 15 || state == 35) {
      if (await _inAppReview.isAvailable()) {
        await _inAppReview.requestReview();
      }
    }
  }
}

final eventCountProvider =
    StateNotifierProvider<EventCountNotifier, int>((ref) {
  return EventCountNotifier();
});
