import 'package:anecdotal/providers/auth_provider.dart';
import 'package:anecdotal/views/home_view.dart';
import 'package:anecdotal/views/onboarding_view.dart';
import 'package:anecdotal/views/sign_in_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          return const AnecdotalAppHome(); // User is signed in
        } else {
          return const SignInScreen(); // User is NOT signed in
        }
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => Scaffold(body: Center(child: Text('Error: $error'))),
    );
  }
}

class OnBoardingAuthWrapper extends ConsumerWidget {
  const OnBoardingAuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          return const AnecdotalAppHome(); // User is signed in
        } else {
          return const OnboardingScreen(); // User is NOT signed in
        }
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => Scaffold(body: Center(child: Text('Error: $error'))),
    );
  }
}