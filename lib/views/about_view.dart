import 'package:anecdotal/utils/constants/writeups.dart';
import 'package:anecdotal/utils/reusable_function.dart';
import 'package:anecdotal/widgets/smaller_reusable_widgets.dart';
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
                child: Text(
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
                  label: Text("Send Us A Mail"),
                  icon: Icon(Icons.mail),
                ),
              ),
              mySpacing(),
              Center(
                child: SelectableText(
                  "okechukwu@habilisfusion.co",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
              _buildSection(
                'Our Mission',
                'People who deal with chronic illnesses often burn through multiple doctors and limited financial resources before getting an accurate diagnosis. Anecdotal aims to empower people with knowledge, connect them with a supportive community, shorten their journey to recovery, and provide tools for managing their health journey.',
                Icons.flag,
              ),
              _buildSection(
                'The Story Behind Anecdotal',
                "Anecdotal was born out of personal experience and a deep understanding of the challenges of chronic illness (CIRS). As a survivor and thriver, I drew upon my own journey to design an app that tackles the complexities and uncertainties of these conditions head-on. Having navigated the struggles and frustrations of navigating health challenges firsthand, I created Anecdotal as the tool I wished I had during my darkest days of uncertainty. This app is a labor of love, driven by a passion to support and empower others on their paths to recovery and wellness.",
                Icons.person,
              ),
              _buildSection(
                'What Anecdotal Offers',
                '',
                Icons.star,
                children: [
                  _buildFeature('Symptom Tracking',
                      'Log daily symptoms and visualize patterns over time.'),
                  _buildFeature('Community Support',
                      'Connect with others who understand your struggles.  (Coming Soon)'),
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
                      'Upload or take photos of suspected mold growth or water damage in your home to report or assess environmental triggers for analysis.'),
                  _buildFeature('AI Chat and Voice Interface',
                      'Ask questions about your condition and get personalized responses based on AI analysis.'),
                  _buildFeature('Lab Result Interpretation',
                      'Upload lab results and receive an AI-powered preliminary analysis and report.'),
                  _buildFeature('Find a Doctor',
                      'Search for doctors who specialize in mold illness and CIRS treatment.  (Coming Soon)'),
                  _buildFeature('Lifestyle Adjustments',
                      'Access lifestyle tips and recommendations to help manage your condition.  (Coming Soon)'),
                  _buildFeature('Explainer for Loved Ones',
                      'Share a video with family or colleagues to help them understand your invisible, yet debilitating, illness and spread awareness.  (Coming Soon)'),
                ],
              ),
              const SizedBox(height: 20),
              _buildSection(
                "Our Mission to Support More",
                futureSupport,
                Icons.health_and_safety,
              ),
              _buildSection(
                'Our Commitment',
                'We believe that no one should face chronic illness alone. We\'re committed to continually improving our app based on user feedback and the latest medical research.',
                Icons.favorite,
              ),
              const Center(
                child: Text(
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
                  label: Text("Send Us A Mail"),
                  icon: Icon(Icons.mail),
                ),
              ),
              mySpacing(),
              Center(
                child: SelectableText(
                  "okechukwu@habilisfusion.co",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
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
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
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
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
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
