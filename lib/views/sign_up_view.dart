// sign_up_screen.dart
import 'dart:io';

import 'package:anecdotal/services/auth_service.dart';
import 'package:anecdotal/utils/constants/constants.dart';

import 'package:anecdotal/widgets/reusable_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      if (_authService.isUserAnonymous()) {
        // Link the anonymous account with email and password
        await _authService.linkAnonymousAccountWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      } else {
        // Proceed with normal sign-up
        await _signUpWithEmailAndPassword();
      }
      Navigator.pushReplacementNamed(context, AppRoutes.authWrapper);
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      await _authService.signInWithGoogle();

      Navigator.pushReplacementNamed(context, AppRoutes.authWrapper);
      // Navigate to the home screen
    } on FirebaseAuthException {
      print('crap');
    }
  }

  Future<void> _signUpWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _authService.signUpWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        Navigator.pushReplacementNamed(context, AppRoutes.authWrapper);
      } on FirebaseAuthException {
        // Handle sign-up error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Create Your Account')),
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
                const MyCircularImage(imageUrl: logoAssetImageUrlNoTagLine),
                mySpacing(spacing: 20),
                if (authService.isUserAnonymous())
                  Text(
                    "Creating an account with an email and password will preserve your data and enable you access it on other devices using your login credentials.",
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                mySpacing(),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
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
                    border: const OutlineInputBorder(),
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
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton.icon(
                  onPressed: _handleSignUp,
                  label: const Text('Create Account'),
                  icon: const Icon(Icons.auto_awesome),
                ),
                mySpacing(),
                if (!kIsWeb)
                  if (Platform.isAndroid) ...[
                    const SizedBox(height: 16.0),
                    OutlinedButton.icon(
                      onPressed: _signInWithGoogle,
                      icon: const Icon(Icons.person),
                      label: const Text('Sign In with Google'),
                    ),
                  ],
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: PrivacyAndTermsButton(
                    showAbout: true,
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
