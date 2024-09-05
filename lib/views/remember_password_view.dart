// password_recovery_screen.dart
import 'package:anecdotal/services/auth_service.dart';
import 'package:anecdotal/utils/constants.dart';

import 'package:anecdotal/widgets/smaller_reusable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  _PasswordRecoveryScreenState createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _authService.resetPassword(_emailController.text.trim());
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Password reset email sent. Please check your inbox.'),
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.of(context).pop(); // Navigate back to the sign-in screen
      } on FirebaseAuthException catch (e) {
        // Handle password reset error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error resetting password. Please try again. \n $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Password Recovery')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const MyCircularImage(imageUrl: logoAssetImageUrlNoTagLine),
              mySpacing(spacing: 20),
              Text(
                'Enter your email address to receive a password reset link.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16.0),
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
              ElevatedButton(
                onPressed: _resetPassword,
                child: const Text('Reset Password'),
              ),

               mySpacing(),
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
    );
  }
}
