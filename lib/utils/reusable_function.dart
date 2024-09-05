import 'package:flutter/material.dart';

import 'package:toastification/toastification.dart';

class MyReusableFunctions {
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

  static Future<void> myReusableCustomDialog({
    required BuildContext context,
    Widget? widget,
    required IconData icon,
    Color? dialogIconColor,
    List<Widget>? actions,
    String? message,
    String? actionButtonText,
    Color? textColor,
    bool barrierDismissible = true,
  }) {
    return showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) => AlertDialog(
        title: Icon(
          icon,
          size: 40,
          color: dialogIconColor ?? Theme.of(context).iconTheme.color,
        ),
        content: widget ??
            Text(
              message ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16, // Adjust the font size as needed
                color:
                    textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
                fontWeight: FontWeight.bold,
              ),
            ),
        actions: actions ??
            <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  actionButtonText ?? 'Close',
                  style: TextStyle(
                    fontSize: 16, // Adjust the font size as needed
                    color: dialogIconColor ?? Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
      ),
    );
  }
}
