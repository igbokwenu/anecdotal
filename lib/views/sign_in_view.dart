// sign_in_screen.dart

import 'dart:io';

import 'package:anecdotal/services/auth_service.dart';
import 'package:anecdotal/utils/constants/constants.dart';
import 'package:anecdotal/utils/reusable_function.dart';
import 'package:anecdotal/views/download_view.dart';
import 'package:anecdotal/widgets/reusable_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final _authService = AuthService();
  bool isButtonLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedEmail();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void changeButtonLoadingState() {
    setState(() {
      isButtonLoading = !isButtonLoading;
    });
  }

  Future<void> _loadSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    if (savedEmail != null) {
      _emailController.text = savedEmail;
    }
  }

  Future<void> _signInWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      changeButtonLoadingState();
      try {
        await _authService.signInWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        changeButtonLoadingState();
        Navigator.pushReplacementNamed(context, AppRoutes.authWrapper);
        // Navigate to the home screen
      } on FirebaseAuthException {
        changeButtonLoadingState();
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    changeButtonLoadingState();
    try {
      await _authService.signInWithGoogle();

      changeButtonLoadingState();
      Navigator.pushReplacementNamed(context, AppRoutes.authWrapper);
      // Navigate to the home screen
    } on FirebaseAuthException {
      changeButtonLoadingState();
    }
  }

  Future<void> _signInAnonymously() async {
    changeButtonLoadingState();
    try {
      await _authService.signInAnonymously();
      changeButtonLoadingState();
      Navigator.pushReplacementNamed(context, AppRoutes.authWrapper);
      // Navigate to the home screen
    } on FirebaseAuthException catch (e) {
      changeButtonLoadingState();
      MyReusableFunctions.showCustomToast(
        description: "Error: $e",
        type: ToastificationType.error,
      );
      // Handle sign-in error
    }
  }

  void _navigateToPasswordRecovery() {
    Navigator.pushNamed(context, AppRoutes.passwordRecovery);
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? const DownloadPage()
        : Scaffold(
            appBar: AppBar(
              title: const Center(
                  child: MyAppBarTitleWithAI(title: "Welcome To Anecdotal AI")),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // const MyCircularImage(
                      //   imageUrl: anecdotalMascotAssetUrl,
                      //   hasBorder: false,
                      //   size: 120,
                      // ),
                      // mySpacing(),
                      // Text(
                      //   "A soothing space to find answers, heal, and connect with others who truly understand 🤍.",
                      //   textAlign: TextAlign.center,
                      //   style: Theme.of(context).textTheme.labelLarge,
                      // ),
                      mySpacing(spacing: 20),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.mail),
                        ),
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value!.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _navigateToPasswordRecovery,
                          child: const Text('Forgot Password'),
                        ),
                      ),
                      isButtonLoading
                          ? const Padding(
                              padding: EdgeInsets.only(bottom: 203.0),
                              child: MySpinKitWaveSpinner(),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: _signInWithEmailAndPassword,
                                  label: const Text('Sign In'),
                                  icon: const Icon(Icons.auto_awesome),
                                ),
                                mySpacing(spacing: 25),
                                const Divider(
                                  height: 10,
                                  indent: 60,
                                  endIndent: 60,
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, AppRoutes.signUp);
                                  },
                                  label: const Text('Create Account'),
                                  icon: const Icon(Icons.person_add),
                                ),
                                mySpacing(),
                                ElevatedButton.icon(
                                  onPressed: _signInAnonymously,
                                  label: const Text('Continue Anonymously'),
                                  icon: const Icon(Icons.visibility_off),
                                ),
                                if (!kIsWeb)
                                  if (Platform.isAndroid) ...[
                                    const SizedBox(height: 16.0),
                                    OutlinedButton.icon(
                                      onPressed: _signInWithGoogle,
                                      icon: const Icon(Icons.person),
                                      label: const Text('Sign In with Google'),
                                    ),
                                  ],
                              ],
                            ),
                      mySpacing(),
                      const Align(
                        alignment: Alignment.bottomCenter,
                        child: PrivacyAndTermsButton(
                          showAbout: true,
                          showDownload: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
