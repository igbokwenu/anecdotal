import 'package:anecdotal/utils/reusable_function.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class ReportView extends StatelessWidget {
  final String summaryContent;
  final List<String> keyInsights;
  final List<String> recommendations;
  final List<String> followUpSuggestions;
  final String? title;

  const ReportView({
    super.key,
    required this.summaryContent,
    required this.keyInsights,
    required this.recommendations,
    required this.followUpSuggestions,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<Widget> _buildSearchTerms(List<String> points) {
      return points
          .map((point) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Icon(Icons.health_and_safety_rounded),
                    // const SizedBox(width: 8),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          label: Text(
                            point,
                            style: theme.textTheme.bodyMedium,
                          ),
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            MyReusableFunctions.launchGoogleSearch(point);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Pulse(
              delay: const Duration(milliseconds: 5000),
              child: const Icon(Icons.auto_awesome),
            ),
            const SizedBox(width: 10),
            Text(
              title ?? 'Highlights',
              style: theme.textTheme.headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Section
            _buildSection(
              title: 'Summary',
              icon: Icons.notes,
              color: theme.colorScheme.primary,
              children: [
                _buildParagraph(summaryContent),
              ],
            ),
            // Insights Section
            _buildSection(
              title: 'Key Insights',
              icon: Icons.lightbulb_outline,
              color: theme.colorScheme.secondary,
              children: _buildBulletPoints(keyInsights),
            ),
            // Recommendations Section
            _buildSection(
              title: "Recommendations",
              icon: Icons.list_rounded,
              color: theme.colorScheme.tertiary,
              children: _buildToDoItems(recommendations),
            ),
            // Follow Up Suggestions Section
            _buildSection(
              title: 'Follow Up Search Terms',
              icon: Icons.directions_run,
              color: theme.colorScheme.primaryFixedDim,
              children: _buildSearchTerms(followUpSuggestions),
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
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(),
          ...children,
        ],
      ),
    );
  }

  Widget _buildParagraph(String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        content,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  List<Widget> _buildBulletPoints(List<String> points) {
    return points
        .map((point) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.health_and_safety_rounded),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      point,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }

  List<Widget> _buildToDoItems(List<String> items) {
    return items
        .map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_outline, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }
}
