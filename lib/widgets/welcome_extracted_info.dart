import 'package:flutter/material.dart';

class ExtractedInfoDisplay extends StatelessWidget {
  final Map<String, dynamic> extractedInfo;

  const ExtractedInfoDisplay({
    super.key,
    required this.extractedInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Setup"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Personal Details"),
            _buildInfoCard(
              "Name",
              "${extractedInfo['firstName'] ?? 'N/A'} ${extractedInfo['lastName'] ?? 'N/A'}",
              Icons.person,
            ),
            _buildInfoCard(
              "Gender",
              extractedInfo['gender'] ?? 'N/A',
              Icons.transgender,
            ),
            const SizedBox(height: 16.0),
            _buildSectionTitle("Location"),
            _buildInfoCard(
              "Country",
              extractedInfo['country'] ?? 'N/A',
              Icons.flag,
            ),
            _buildInfoCard(
              "State/Province",
              extractedInfo['state'] ?? 'N/A',
              Icons.location_on,
            ),
            const SizedBox(height: 16.0),
            _buildSectionTitle("Symptoms"),
            _buildInfoCard(
              "Known Symptoms",
              _formatList(extractedInfo['knownSymptoms'] ?? []),
              Icons.local_hospital,
            ),
            _buildInfoCard(
              "Unknown Symptoms",
              _formatList(extractedInfo['unknownSymptoms'] ?? []),
              Icons.warning,
            ),
            const SizedBox(height: 16.0),
            _buildSectionTitle("Recommendations"),
            _buildInfoCard(
              "Recommended Actions",
              _formatList(extractedInfo['recommendations'] ?? []),
              Icons.assignment_turned_in,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content, IconData icon) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title),
        subtitle: Text(content.isNotEmpty ? content : 'Not provided'),
      ),
    );
  }

  String _formatList(List<String> items) {
    return items.isNotEmpty ? items.join(', ') : 'No items';
  }
}
