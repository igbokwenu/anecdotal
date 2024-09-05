import 'package:anecdotal/widgets/legal_page_template.dart';
import 'package:flutter/material.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalPage(
      title: 'Terms of Service',
      content: '''
# Terms of Service for Anecdotal

Last updated: [Date]

Please read these Terms of Service ("Terms", "Terms of Service") carefully before using the Anecdotal mobile application (the "Service") operated by The Developer of Anecdotal ("us", "we", or "our").

## 1. Acceptance of Terms

By accessing or using the Service, you agree to be bound by these Terms. If you disagree with any part of the terms, then you may not access the Service.

## 2. Description of Service

Anecdotal is a mobile application designed to assist individuals in managing chronic inflammatory response syndrome (CIRS) and other chronic conditions. The app provides various features including progress tracking, symptom checking, treatment suggestions, and community forums.

## 3. User Accounts and Responsibilities

3.1. You are responsible for maintaining the confidentiality of your account and password.

3.2. You agree to accept responsibility for any and all activities or actions that occur under your account and/or password.

3.3. You must notify us immediately upon becoming aware of any breach of security or unauthorized use of your account.

## 4. User-Generated Content

4.1. Our Service allows you to post, link, store, share and otherwise make available certain information, text, graphics, videos, or other material ("Content").

4.2. You are responsible for the Content that you post to the Service, including its legality, reliability, and appropriateness.

4.3. By posting Content to the Service, you grant us the right and license to use, modify, publicly perform, publicly display, reproduce, and distribute such Content on and through the Service.

## 5. Intellectual Property

The Service and its original content (excluding Content provided by users), features and functionality are and will remain the exclusive property of The Developer of Anecdotal and its licensors.

## 6. Links To Other Web Sites

Our Service may contain links to third-party web sites or services that are not owned or controlled by The Developer of Anecdotal. We have no control over, and assume no responsibility for, the content, privacy policies, or practices of any third party web sites or services.

## 7. Termination

We may terminate or suspend access to our Service immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.

## 8. Limitation of Liability

In no event shall The Developer of Anecdotal, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from your access to or use of or inability to access or use the Service.

## 9. Medical Disclaimer

9.1. The information provided through the Service is for general informational purposes only and is not intended as, nor should it be considered a substitute for, professional medical advice.

9.2. Always seek the advice of your physician or other qualified health provider with any questions you may have regarding a medical condition.

9.3. The Developer of Anecdotal is not liable for any decisions made or actions taken based on the information provided through the Service.

## 10. Changes to Terms

We reserve the right, at our sole discretion, to modify or replace these Terms at any time. We will provide notice of any significant changes to these Terms.

## 11. Governing Law

These Terms shall be governed and construed in accordance with the laws of [Your Jurisdiction], without regard to its conflict of law provisions.

## 12. Contact Us

If you have any questions about these Terms, please contact us:
- By email: [Your Contact Email]
''',
    );
  }
}
