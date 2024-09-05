import 'package:anecdotal/widgets/legal_page_template.dart';
import 'package:flutter/material.dart';




class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Anecdotal - Legal')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Privacy Policy'),
              onPressed: () => Navigator.pushNamed(context, '/privacy'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Terms of Service'),
              onPressed: () => Navigator.pushNamed(context, '/terms'),
            ),
          ],
        ),
      ),
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalPage(
      title: 'Privacy Policy',
      content: '''
# Privacy Policy for Anecdotal

Last updated: [Date]

The Developer of Anecdotal ("we", "us", or "our") operates the Anecdotal mobile application (the "Service"). This page informs you of our policies regarding the collection, use, and disclosure of personal data when you use our Service and the choices you have associated with that data.

## 1. Information Collection and Use

We collect several different types of information for various purposes to provide and improve our Service to you.

### Types of Data Collected

#### Personal Data
While using our Service, we may ask you to provide us with certain personally identifiable information that can be used to contact or identify you ("Personal Data"). This may include, but is not limited to:
- Email address
- First name and last name
- Phone number
- Address, State, Province, ZIP/Postal code, City
- Cookies and Usage Data

#### Health Data
Our app collects and processes health-related data, including but not limited to:
- Symptoms
- Treatments
- Progress reports
- Voice recordings for analysis
- Photos for progress tracking
- Lab results

This data is used to provide personalized suggestions, track your health journey, and improve our Service.

#### Usage Data
We may also collect information on how the Service is accessed and used ("Usage Data"). This may include information such as your device's Internet Protocol address (e.g., IP address), browser type, browser version, the pages of our Service that you visit, the time and date of your visit, the time spent on those pages, unique device identifiers, and other diagnostic data.

## 2. Use of Data

Anecdotal uses the collected data for various purposes:
- To provide and maintain our Service
- To notify you about changes to our Service
- To allow you to participate in interactive features of our Service when you choose to do so
- To provide customer support
- To gather analysis or valuable information so that we can improve our Service
- To monitor the usage of our Service
- To detect, prevent and address technical issues
- To provide personalized health insights and recommendations

## 3. Data Sharing and Third-Party Services

We may share certain data with third-party services to improve and maintain our Service. These may include:
- Specialized AI Language Models (LLMs) for processing health-related queries and providing insights
- Analytics providers to help us understand app usage and improve our services
- Backend-as-a-Service providers for data storage and processing

We ensure that any third-party service we use adheres to strict privacy and security standards. However, we are not responsible for the privacy practices of these third-party services.

## 4. Data Retention and Deletion

You have the right to delete your data at any time. To request data deletion, please contact us at [Your Contact Email]. We will process your request within a reasonable timeframe, typically within 30 days.

Please note that some information may be retained in our backup files or for legal compliance purposes even after you request deletion.

## 5. Data Security

The security of your data is important to us, but remember that no method of transmission over the Internet or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your Personal Data, we cannot guarantee its absolute security.

## 6. Changes to This Privacy Policy

We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last updated" date at the top of this Privacy Policy.

## 7. Contact Us

If you have any questions about this Privacy Policy, please contact us:
- By email: [Your Contact Email]

## 8. Medical Disclaimer

The information provided in the Anecdotal app is for general informational purposes only and should not be considered as medical advice. Always consult with a qualified healthcare professional before making any changes to your treatment or lifestyle.

The Developer of Anecdotal is not liable for any decisions made or actions taken based on the information provided in the app.
''',
    );
  }
}


