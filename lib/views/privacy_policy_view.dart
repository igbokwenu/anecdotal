import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              'Privacy Policy for Anecdotal',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'The Developer of Anecdotal values your privacy. We ensure that your data is handled responsibly. '
              'You have the right to delete your data at any time. Some data you provide might be shared with '
              'third-party services, such as AI models, analytics, and backend service providers. We use these '
              'services to enhance your experience but will only share data necessary for their functionality.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Medical Disclaimer',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'The information provided in this app is not medical advice. The content and services offered are '
              'for informational purposes only, and The Developer is not liable for any decisions made based on '
              'this information. Always consult a healthcare professional for medical advice.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Data Deletion',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'You can delete your data from the app at any time. Simply navigate to the "Account" section and select the "Delete Account" option.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Third-Party Services',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'We collaborate with third-party service providers to improve your experience, such as specialized AI services for voice analysis, symptom checking, and other app features. '
              'By using the app, you agree to share relevant data with these services as necessary.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
