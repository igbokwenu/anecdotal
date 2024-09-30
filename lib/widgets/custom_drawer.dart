import 'package:anecdotal/providers/iap_provider.dart';
import 'package:anecdotal/providers/in_app_review_provider.dart';
import 'package:anecdotal/providers/user_data_provider.dart';
import 'package:anecdotal/services/auth_service.dart';
import 'package:anecdotal/utils/constants/constants.dart';
import 'package:anecdotal/utils/reusable_function.dart';
import 'package:anecdotal/views/account_view.dart';
import 'package:anecdotal/views/chat/rooms.dart';
import 'package:anecdotal/views/community_chat/community_chat_utils.dart';
import 'package:anecdotal/views/delete_account_view.dart';
import 'package:anecdotal/views/to_do_view.dart';
import 'package:anecdotal/views/view_reports_view.dart';
import 'package:anecdotal/widgets/reusable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

class CustomDrawer extends ConsumerWidget {
  final AdvancedDrawerController controller;

  const CustomDrawer({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iapStatus = ref.watch(iapProvider);
    ref.read(iapProvider.notifier).checkAndSetIAPStatus();
    final authService = AuthService();
    final user = FirebaseAuth.instance.currentUser;
    final userData = ref.watch(anecdotalUserDataProvider(user!.uid)).value;

    return SafeArea(
      child: ListTileTheme(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            mySpacing(spacing: 45),
            userData == null || userData.profilePicUrl == null
                ? const MySpinKitWaveSpinner()
                : MyCircularImage(
                    imageUrl: userData.profilePicUrl!.isEmpty
                        ? logoAssetImageUrlCircular
                        : userData.profilePicUrl!,
                    size: 118,
                    isAsset: userData.profilePicUrl!.isEmpty ? true : false,
                    hasBorder: userData.profilePicUrl!.isEmpty ? false : true,
                  ),
            mySpacing(),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccountPage(),
                  ),
                );
                // Navigator.pushNamed(context, AppRoutes.account);
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
            if (!kIsWeb)
              ListTile(
                onTap: () {
                  CommunityChatUtils.navigateToCommunityChat(context);
                },
                leading: const Icon(Icons.groups),
                title: const Text('Community Chat'),
              ),
            if (!kIsWeb)
              if (kDebugMode || kProfileMode)
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RoomsPage(),
                      ),
                    );
                  },
                  leading: const Icon(Icons.mail),
                  title: const Text('Private Chat'),
                ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ToDoScreen(),
                  ),
                );
                // Navigator.pushNamed(context, AppRoutes.account);
              },
              leading: const Icon(Icons.task),
              title: const Text('Healing Tasks'),
            ),
            ListTile(
              onTap: () {
                ref.read(eventCountProvider.notifier).incrementEventCount();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewReports(),
                  ),
                );
              },
              leading: const Icon(Icons.file_copy),
              title: const Text('View Reports'),
            ),
            if (!kIsWeb)
              ListTile(
                onTap: () async {
                  iapStatus.isPro
                      ? MyReusableFunctions.showCustomDialog(
                          context: context,
                          message: 'You are already a pro user')
                      : await RevenueCatUI.presentPaywall();
                },
                leading: const Icon(Icons.monetization_on),
                title: const Text('Subscription'),
              ),
            ListTile(
              onTap: () {
                MyReusableFunctions.launchMail();
              },
              leading: const Icon(Icons.contact_support),
              title: const Text('Contact Us'),
            ),
            const Spacer(),
            ListTile(
              onTap: () async {
                authService.isUserAnonymous()
                    ? MyReusableFunctions.showCustomDialog(
                        context: context,
                        icon: Icons.info,
                        message:
                            "You are signed in anonymously, this means that all your data will be deleted and lost forever if you sign out. Are you sure you want to sign out?",
                        actions: [
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const DeleteAccountPage()),
                                  (Route<dynamic> route) => false,
                                );
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
