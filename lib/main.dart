import 'package:anecdotal/firebase_options.dart';
import 'package:anecdotal/providers/theme_provider.dart';
import 'package:anecdotal/services/auth_wrapper.dart';
import 'package:anecdotal/services/iap/config.dart';
import 'package:anecdotal/utils/constants/constants.dart';
import 'package:anecdotal/utils/themes.dart';
import 'package:anecdotal/views/about_view.dart';
import 'package:anecdotal/views/account_view.dart';
import 'package:anecdotal/views/download_view.dart';
import 'package:anecdotal/views/privacy_policy_view.dart';
import 'package:anecdotal/views/remember_password_view.dart';
import 'package:anecdotal/views/sign_up_view.dart';
import 'package:anecdotal/views/terms_of_service_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  if (!kIsWeb) {
    setRevenueCatStoreConfig();
  }

  WidgetsFlutterBinding.ensureInitialized();
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  // FlutterError.onError = (errorDetails) {
  //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  // };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };
  if (!kIsWeb) {
    await configureRevenueCatSdk();
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setPathUrlStrategy();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// lib/main.dart

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return ToastificationWrapper(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Anecdotal',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        // home: const AnecdotalAppHome(),
        initialRoute: '/',
        routes: {
          AppRoutes.authWrapper: (context) => const AuthWrapper(),
          AppRoutes.signUp: (context) => const SignUpScreen(),
          AppRoutes.passwordRecovery: (context) =>
              const PasswordRecoveryScreen(),
          // AppRoutes.home: (context) => const AnecdotalAppHome(),
          AppRoutes.about: (context) => const AboutPage(),
          AppRoutes.privacy: (context) => const PrivacyPolicyPage(),
          AppRoutes.terms: (context) => const TermsOfServicePage(),
          AppRoutes.account: (context) => const AccountPage(),
          AppRoutes.download: (context) => const DownloadPage(),
          AppRoutes.onboardingWrapper: (context) => const OnBoardingAuthWrapper(),
        },
      ),
    );
  }
}
