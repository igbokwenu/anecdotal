import 'package:anecdotal/services/animated_navigator.dart';
import 'package:anecdotal/services/auth_service.dart';
import 'package:anecdotal/utils/constants.dart';
import 'package:anecdotal/utils/reusable_function.dart';
import 'package:anecdotal/views/about_view.dart';
import 'package:anecdotal/views/account_view.dart';
import 'package:anecdotal/views/welcome_view.dart';
import 'package:anecdotal/widgets/smaller_reusable_widgets.dart';
import 'package:anecdotal/widgets/test_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

class CustomDrawer extends StatelessWidget {
  final AdvancedDrawerController controller;

  const CustomDrawer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    return SafeArea(
      child: ListTileTheme(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 128.0,
              height: 128.0,
              margin: const EdgeInsets.only(
                top: 24.0,
                bottom: 64.0,
              ),
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                logoAssetImageUrlCircular,
                fit: BoxFit.cover,
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.account);
              },
              leading: const Icon(Icons.account_circle_rounded),
              title: const Text('Account'),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.about);
              },
              leading: const Icon(Icons.info),
              title: const Text('About'),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  slideLeftTransitionPageBuilder(
                    CameraWidget(
                      prompt: "Analyze this image and tell me what you see",
                      onResponse: (response) {
                        if (response != null) {
                          MyReusableFunctions.myReusableCustomDialog(
                            context: context,
                            message: "AI Response: $response",
                            icon: Icons.info_outline_rounded,
                          );
                          print("AI Response: $response");
                        }
                      },
                      onComplete: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => AnalysisResultPage()),
                        // );
                      },
                    ),
                  ),
                );
              },
              leading: const Icon(Icons.chat),
              title: const Text('Chat Room'),
            ),
            ListTile(
              onTap: () async{
                await RevenueCatUI.presentPaywall();
                // Navigator.push(
                //   context,
                //   slideLeftTransitionPageBuilder(
                //     OnboardingScreen(),
                //   ),
                // );
              },
              leading: const Icon(Icons.monetization_on),
              title: const Text('Subscription'),
            ),
            ListTile(
              onTap: () {
                // Navigate to Contact Us
              },
              leading: const Icon(Icons.contact_support),
              title: const Text('Contact Us'),
            ),
            const Spacer(),
            ListTile(
              onTap: () async {
                authService.isUserAnonymous()
                    ? MyReusableFunctions.myReusableCustomDialog(
                        context: context,
                        icon: Icons.info,
                        message:
                            "You are signed in anonymously, this means that all your data will be deleted and lost forever if you sign out. Are you sure you want to sign out?",
                        actions: [
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await authService.deleteUser();
                                await authService.signOut();
                                Navigator.pushReplacementNamed(
                                    context, AppRoutes.authWrapper);
                              },
                              child: const Text("Sign Out"),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.pushNamed(context, AppRoutes.signUp);
                              },
                              child: const Text("Link Account"),
                            ),
                          ])
                    : await authService.signOut();
                // Navigator.pushReplacementNamed(context, AppRoutes.authWrapper);
              },
              leading: const Icon(Icons.logout_rounded),
              title: const Text('Sign Out'),
            ),
            const PrivacyAndTermsButton(),
          ],
        ),
      ),
    );
  }
}
