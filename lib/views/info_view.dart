import 'package:anecdotal/widgets/smaller_reusable_widgets.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class InfoView extends StatelessWidget {
  final String? title;
  final String? patientsName;
  final String? sectionSummary;
  final Widget? firstWidget;
  final Widget? secondWidget;
  const InfoView({
    super.key,
    this.patientsName,
    this.sectionSummary,
    this.firstWidget,
    this.secondWidget,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Pulse(
                delay: const Duration(milliseconds: 2000),
                child: const Icon(Icons.auto_awesome)),
            const SizedBox(width: 10),
            Text(
              title ?? 'Analyze Your Symptoms',
              style: theme.textTheme.titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            mySizedBox(height: 10),
            _buildHeader(context),
            _buildSection(
              context,
              title: 'Section Summary',
              icon: Icons.lightbulb,
              content: sectionSummary ??
                  'Here, we take a look at your symptoms and give you a general idea of if you might be dealing with Mold illness.',
            ),
            firstWidget ?? myEmptySizedBox(),
            secondWidget ?? myEmptySizedBox(),
            _buildSuggestions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            patientsName ?? 'Amanda Davis',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
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
                  style: Theme.of(context).textTheme.titleMedium,
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
                  'Follow Up Suggestions',
                  style: Theme.of(context).textTheme.headlineSmall,
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
