import 'package:anecdotal/utils/constants/writeups.dart';
import 'package:anecdotal/utils/reusable_function.dart';
import 'package:anecdotal/widgets/reusable_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('About Anecdotal')),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: SelectableText(
                  'Patient Inspired Health Solution 🤍',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
              mySpacing(),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    MyReusableFunctions.launchMail();
                  },
                  label: const SelectableText("Send Us A Mail"),
                  icon: const Icon(Icons.mail),
                ),
              ),
              if (kIsWeb) mySpacing(),
              Center(
                child: SelectableText(
                  "okechukwu@habilisfusion.co",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
              _buildSection(
                'Our Mission',
                anecdotalMainPitch,
                Icons.flag,
              ),
              _buildSection(
                'The Story Behind Anecdotal',
                "Anecdotal was born out of personal experience and a deep understanding of the challenges of chronic illness (CIRS). As a survivor and thriver, I drew upon my own journey to design an app that tackles the complexities and uncertainties of these conditions head-on. Having navigated the struggles and frustrations of navigating health challenges firsthand, I created Anecdotal as the tool I wished I had during my darkest days of uncertainty. This app is a labor of love, driven by a passion to support and empower others on their paths to recovery and wellness.",
                Icons.person,
              ),
              const SizedBox(height: 20),
              _buildSection(
                "Our Mission to Support More",
                futureSupport,
                Icons.health_and_safety,
              ),
              _buildSection(
                'What Anecdotal Offers',
                '',
                Icons.star,
                children: [
                  _buildFeature('Symptom Tracking',
                      'Log daily symptoms and visualize patterns over time.'),
                  _buildFeature('Community Support',
                      'Connect with others who understand your struggles with our Community Chat room.'),
                  _buildFeature('Explainer for Loved Ones',
                      'Share videos and citations with family or colleagues to help them understand your invisible, yet debilitating, illness and spread awareness.'),
                  _buildFeature('Expert Insights',
                      'Access curated information from specialized doctors.'),
                  _buildFeature('Treatment Logging',
                      'Keep track of treatments and their effects.'),
                  _buildFeature('Environmental Monitoring',
                      'Log and track potential environmental triggers in your surroundings.'),
                  _buildFeature('Resource Hub',
                      'Find trusted resources and the latest research to support your journey.'),
                  _buildFeature('AI-Powered Symptom Checker',
                      'Use AI to analyze your symptoms and get potential explanations.'),
                  _buildFeature('Voice Analysis Progress Tracker',
                      'Document your daily treatments and progress using voice chat, while tracking your symptoms and healing journey.'),
                  _buildFeature('Home Investigation Tool',
                      'Upload or take photos of suspected toxins or toxic areas in your environment and we will assess the images for environmental triggers.'),
                  _buildFeature('AI Chat and Voice Interface',
                      'Ask questions about your condition and get personalized responses based on AI analysis.'),
                  _buildFeature('Lab Result Interpretation',
                      'Upload lab results and receive an AI-powered preliminary analysis and report.'),
                  _buildFeature('Find a Doctor',
                      'Find doctors who specialize in functional medicine.  (Coming Soon)'),
                  _buildFeature('Lifestyle Adjustments',
                      'Access lifestyle tips and recommendations to help manage your condition.'),
                ],
              ),
              _buildSection(
                'Our Commitment',
                'We believe that no one should face chronic illness alone. We\'re committed to continually improving our app based on user feedback and the latest medical research.',
                Icons.favorite,
              ),
              const Center(
                child: SelectableText(
                  'Anecdotal: A better path to healing.',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.teal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              mySpacing(),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    MyReusableFunctions.launchMail();
                  },
                  label: const SelectableText("Send Us A Mail"),
                  icon: const Icon(Icons.mail),
                ),
              ),
              if (kIsWeb) mySpacing(),
              Center(
                child: SelectableText(
                  "okechukwu@habilisfusion.co",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
              mySpacing(),
              const Divider(),
              const PrivacyAndTermsButton(
                showDownload: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon,
      {List<Widget>? children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            Icon(icon, color: Colors.teal),
            const SizedBox(width: 10),
            SelectableText(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SelectableText(
          content,
          style: const TextStyle(fontSize: 16),
        ),
        if (children != null) ...children,
      ],
    );
  }

  Widget _buildFeature(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.teal, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SelectableText(
                  description,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
