import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Anecdotal'),
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
                  'By patients, for patients',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildSection(
                'Our Mission',
                'Anecdotal aims to empower patients with knowledge, connect them with a supportive community, and provide tools for managing their health journey.',
                Icons.flag,
              ),
              _buildSection(
                'The Story Behind Anecdotal',
                'Increase, the designer of Anecdotal, is not just a creator but a fellow traveler on the path to recovery from mold illness. His personal struggle inspired the creation of this app, ensuring that every feature is crafted with genuine understanding and empathy.',
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
                      'Connect with others who understand your struggles.'),
                  _buildFeature('Expert Insights',
                      'Access curated information from specialized doctors.'),
                  _buildFeature('Treatment Logging',
                      'Keep track of treatments and their effects.'),
                  _buildFeature('Environmental Monitoring',
                      'Log and track potential environmental triggers.'),
                  _buildFeature('Resource Hub',
                      'Find trusted resources and latest research.'),
                ],
              ),
              _buildSection(
                'Our Commitment',
                'We believe that no one should face chronic illness alone. We\'re committed to continually improving our app based on user feedback and the latest medical research.',
                Icons.favorite,
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Anecdotal: Your story matters, your health matters.',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.teal,
                  ),
                  textAlign: TextAlign.center,
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
