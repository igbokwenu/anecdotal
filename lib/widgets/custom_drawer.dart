import 'package:anecdotal/services/animated_navigator.dart';
import 'package:anecdotal/services/auth_service.dart';
import 'package:anecdotal/utils/constants.dart';
import 'package:anecdotal/views/about_view.dart';
import 'package:anecdotal/widgets/smaller_reusable_widgets.dart';
import 'package:anecdotal/widgets/test_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

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
                'assets/images/anecdotal_logo_rounded_800x800.png',
                fit: BoxFit.cover,
              ),
            ),
            ListTile(
              onTap: () {
                // Navigate to Profile
              },
              leading: const Icon(Icons.account_circle_rounded),
              title: const Text('Profile'),
            ),
            ListTile(
              onTap: () {
                // Navigate to About
                Navigator.push(
                  context,
                  slideLeftTransitionPageBuilder(
                    const AboutPage(),
                  ),
                );
              },
              leading: const Icon(Icons.info),
              title: const Text('About'),
            ),
            ListTile(
              onTap: () {
                // Navigate to Chat Room
              },
              leading: const Icon(Icons.chat),
              title: const Text('Chat Room'),
            ),
            ListTile(
              onTap: () {
                // Navigate to Subscription
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
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  slideLeftTransitionPageBuilder(
                    CameraApp(),
                  ),
                );
              },
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
            ),
            const Spacer(),
            ListTile(
              onTap: () async {
                authService.isUserAnonymous()
                    ? myReusableCustomDialog(
                        context: context,
                        icon: Icons.info,
                        message:
                            "You are signed in anonymously, this means that all your data will be lost forever if you sign out now. Are you sure you want to sign out?",
                        widget: TextButton(
                          onPressed: () async {
                            authService.deleteUser();
                            await authService.signOut();
                            Navigator.pop(context);
                          },
                          child: Text("Sign Out & Delete Account"),
                        ),
                      )
                    : await authService.signOut();
                // Navigator.pushReplacementNamed(context, AppRoutes.authWrapper);
              },
              leading: const Icon(Icons.logout_rounded),
              title: const Text('Sign Out'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigate to Terms of Service
                    },
                    child: Text(
                      'Terms of Service',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                  const Text(
                    '|',
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to Privacy Policy
                    },
                    child: Text(
                      'Privacy Policy',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
