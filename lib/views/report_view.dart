import 'package:flutter/material.dart';

class ReportView extends StatelessWidget {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(Icons.auto_awesome),
            const SizedBox(width: 10),
            Text(
              'Highlights',
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
                _buildParagraph(
                  "The patient's medical report indicates normal vital signs with a blood pressure of 120/80 mmHg and a heart rate of 72 bpm. Cholesterol levels are within the acceptable range at 190 mg/dL. Overall, the patient's general health appears to be in good condition, with no immediate concerns identified during this examination.",
                ),
              ],
            ),
            // Insights Section
            _buildSection(
              title: 'Key Insights',
              icon: Icons.lightbulb_outline,
              color: theme.colorScheme.secondary,
              children: _buildBulletPoints([
                'No significant cardiovascular issues detected',
                'Moderate risk of diabetes due to family history',
                'Cholesterol levels are within normal range',
              ]),
            ),
            // Recommendations Section
            _buildSection(
              title: "Recommendations",
              icon: Icons.list_rounded,
              color: theme.colorScheme.tertiary,
              children: _buildToDoItems([
                'Maintain a balanced diet rich in fruits and vegetables',
                'Engage in regular physical activity, aiming for 150 minutes per week',
                'Monitor blood glucose levels periodically',
                'Schedule a follow-up appointment in 6 months',
              ]),
            ),
            // Follow Up Suggestions Section
            _buildSection(
              title: 'Follow Up Suggestions',
              icon: Icons.directions_run,
              color: theme.colorScheme.primaryFixedDim,
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
                  // color: color,
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
                  const Icon(Icons.health_and_safety),
                  Expanded(
                    child: Text(
                      " $point",
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

