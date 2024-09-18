import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

class MyReusableFunctions {
  static Future<void> launchMail({String? address}) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    String encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri url = Uri(
      scheme: 'mailto',
      path: address ?? "okechukwu@habilisfusion.co",
      query: encodeQueryParameters(<String, String>{
        'subject': uid == null
            ? 'Enquiries About Anecdotal'
            : '❤️From Anecdotal App❤️',
        'body': uid == null
            ? ''
            : 'Anecdotal User ID: ${FirebaseAuth.instance.currentUser?.uid} \n\n <--- Add Message Below This Text ---> \n\n',
      }),
    );
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  static Future<void> launchGoogleSearch(String searchQuery) async {
    final String url =
        'https://www.google.com/search?q=$searchQuery'; // replace with your desired search engine
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.inAppWebView)) {
      // use inAppWebView to open within the app
      throw Exception('Could not launch search');
    }
  }

  static Future<void> launchCustomUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

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

  static void showProcessingToast({
    String description = '', // Required parameter
    ToastificationType type = ToastificationType.info,
    ToastificationStyle style = ToastificationStyle.flat,
    String title = "Processing... please wait",
    Alignment alignment = Alignment.topCenter,
    Duration duration = const Duration(seconds: 4),
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(12.0)),
    bool applyBlurEffect = false,
    List<BoxShadow>? boxShadow,
  }) {
    toastification.show(
      type: type,
      style: style,
      title: Text(title),
      // description: Text(description),
      alignment: alignment,
      autoCloseDuration: duration,
      borderRadius: borderRadius,
      boxShadow: boxShadow ?? lowModeShadow,
      applyBlurEffect: applyBlurEffect,
    );
  }

  static Future<void> showCustomDialog({
    required BuildContext context,
    Widget? widget,
    IconData? icon,
    Color? dialogIconColor,
    List<Widget>? actions,
    required String message,
    String? actionButtonText,
    Color? textColor,
    bool barrierDismissible = true,
  }) {
    return showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) => AlertDialog(
        title: Icon(
          icon ?? Icons.info,
          size: 40,
          color: dialogIconColor ?? Theme.of(context).iconTheme.color,
        ),
        content: widget ??
            SingleChildScrollView(
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16, // Adjust the font size as needed
                  color:
                      textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
                  fontWeight: FontWeight.bold,
                ),
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
                    color: Theme.of(context).iconTheme.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
      ),
    );
  }

  static Future<void> showPremiumDialog({
    required BuildContext context,
    Widget? widget,
    IconData? icon,
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
          icon ?? Icons.info,
          size: 40,
          color: dialogIconColor ?? Theme.of(context).iconTheme.color,
        ),
        content: widget ??
            Text(
              "Oops, you've reached your free usage limit for some of our premium features! AI magic comes at a cost, and a premium subscription helps us keep it going for you. ${message ?? ''}",
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
                    color: Theme.of(context).iconTheme.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (!kIsWeb) {
                    Navigator.of(context).pop();
                    await RevenueCatUI.presentPaywall();
                  }
                },
                child: Text(
                  actionButtonText ?? 'Get Premium',
                  style: TextStyle(
                    fontSize: 16, // Adjust the font size as needed
                    color: Theme.of(context).iconTheme.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
      ),
    );
  }
}
