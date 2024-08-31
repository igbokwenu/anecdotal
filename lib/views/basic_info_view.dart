import 'package:anecdotal/utils/smaller_reusable_widgets.dart';
import 'package:flutter/material.dart';

class MedicalInfoScreen extends StatelessWidget {
  const MedicalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome),
            SizedBox(
              width: 10,
            ),
            Text('Summary'),
          ],
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            mySizedBox(height: 10),
            Center(child: _buildHeader(context)),
            _buildSection(
              context,
              title: 'Findings',
              icon: Icons.search,
              content: 'Patient shows signs of...',
            ),
            _buildSection(
              context,
              title: 'Insights',
              icon: Icons.lightbulb,
              content: 'Based on the symptoms, it appears...',
            ),
            _buildSuggestions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'John Doe',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'Last updated: August 31, 2024',
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Colors.white70,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context,
      {required String title,
      required IconData icon,
      required String content}) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.recommend, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Suggestions',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            _buildSuggestionButton(
              context,
              title: 'View Lab Results',
              icon: Icons.science,
            ),
            const SizedBox(height: 8),
            _buildSuggestionButton(
              context,
              title: 'Schedule Follow-up',
              icon: Icons.calendar_today,
            ),
            const SizedBox(height: 8),
            _buildSuggestionButton(
              context,
              title: 'Medication List',
              icon: Icons.medication,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionButton(BuildContext context,
      {required String title, required IconData icon}) {
    return ElevatedButton.icon(
      onPressed: () {
        // TODO: Implement navigation
      },
      icon: Icon(icon),
      label: Text(title),
    );
  }
}

class MedicalInfoScreen3 extends StatelessWidget {
  const MedicalInfoScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.auto_awesome),
            SizedBox(
              width: 10,
            ),
            Text(
              'Findings',
              style: theme.textTheme.headlineSmall,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Findings Section
            _buildSection(
              title: 'Summary',
              icon: Icons.notes,
              color: theme.colorScheme.primary,
              children: [
                _buildInfoRow(
                  icon: Icons.info_outline,
                  title: 'Blood Pressure',
                  content: '120/80 mmHg',
                ),
                _buildInfoRow(
                  icon: Icons.info_outline,
                  title: 'Heart Rate',
                  content: '72 bpm',
                ),
                _buildInfoRow(
                  icon: Icons.info_outline,
                  title: 'Cholesterol',
                  content: '190 mg/dL',
                ),
              ],
            ),
            // Insights Section
            _buildSection(
              title: 'Insights',
              icon: Icons.lightbulb_outline,
              color: theme.colorScheme.secondary,
              children: [
                _buildInfoRow(
                  icon: Icons.health_and_safety,
                  title: 'Cardiovascular Health',
                  content: 'No significant issues detected.',
                ),
                _buildInfoRow(
                  icon: Icons.health_and_safety,
                  title: 'Diabetes Risk',
                  content: 'Moderate risk due to family history.',
                ),
              ],
            ),
            // Suggestions Section
            _buildSection(
              title: 'Suggestions',
              icon: Icons.directions_run,
              color: theme.colorScheme.tertiary,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to another screen
                  },
                  icon: const Icon(Icons.directions_bike),
                  label: const Text('Exercise Recommendations'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to another screen
                  },
                  icon: const Icon(Icons.restaurant),
                  label: const Text('Dietary Advice'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16.0),
        // boxShadow: [
        //   BoxShadow(
        //     color: color.withOpacity(0.2),
        //     blurRadius: 2,
        //     spreadRadius: 2,
        //     offset: const Offset(0, 2),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
