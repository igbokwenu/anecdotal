import 'package:anecdotal/widgets/smaller_reusable_widgets.dart';
import 'package:flutter/material.dart';

class GeneralInfoView extends StatelessWidget {
  const GeneralInfoView({super.key});

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
            _buildHeader(context),
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
      // decoration: BoxDecoration(
      //   color: Theme.of(context).primaryColor,
      //   borderRadius: const BorderRadius.all(
      //     Radius.circular(30),
      //   ),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'John Doe',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'Last updated: August 31, 2024',
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  fontStyle: FontStyle.italic,
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
                Icon(icon, color: Theme.of(context).iconTheme.color),
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
                Icon(Icons.recommend, color: Theme.of(context).iconTheme.color),
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
      icon: Icon(
        icon,
        color: Theme.of(context).iconTheme.color,
      ),
      label: Text(title),
    );
  }
}
