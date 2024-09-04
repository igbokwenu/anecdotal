import 'package:flutter/material.dart';

import 'package:toastification/toastification.dart';

class ReusableFunctions {
  // Static method to show custom toast
  static void showCustomToast({
    required String description, // Required parameter
    ToastificationType type = ToastificationType.info,
    ToastificationStyle style = ToastificationStyle.flat,
    String title = "Notice",
    Alignment alignment = Alignment.topCenter,
    Duration duration = const Duration(seconds: 8),
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(12.0)),
    bool applyBlurEffect = false,
    List<BoxShadow>? boxShadow,
  }) {
    toastification.show(
      type: type,
      style: style,
      title: Text(title),
      description: Text(description),
      alignment: alignment,
      autoCloseDuration: duration,
      borderRadius: borderRadius,
      boxShadow: boxShadow ?? lowModeShadow,
      applyBlurEffect: applyBlurEffect,
    );
  }
}
