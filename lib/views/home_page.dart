import 'package:anecdotal/widgets/custom_card_home.dart';
import 'package:anecdotal/widgets/theme_toggle_button.dart';
import 'package:flutter/material.dart';

class AnecdotalAppHome extends StatelessWidget {
  const AnecdotalAppHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anecdotal'),
        actions: const [
          ThemeToggle(),
          SizedBox(width: 10), // Add some padding
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: CarouselView(
            itemExtent: 330,
            shrinkExtent: 200,
            children: [
              buildCard(
                'Progress Tracker',
                Icons.track_changes,
                'Track your daily treatments and feelings',
                () {
                  // TODO: Implement progress tracker functionality
                },
              ),
              buildCard(
                'Symptom Checker',
                Icons.health_and_safety,
                'Tell us your symptoms to enable us check if you might have Mold illness,',
                () {
                  // TODO: Implement symptom checker functionality
                },
              ),
              buildCard(
                'Home Treatments',
                Icons.home,
                'Pocket-friendly options for treating MARCons and Toxins',
                () {
                  // TODO: Implement home treatments functionality
                },
              ),
              buildCard(
                'Is This Making Me Sick?',
                Icons.camera_alt,
                'Take pictures of potential mold growth',
                () {
                  // TODO: Implement picture taking functionality
                },
              ),
              buildCard(
                'Chat with AI',
                Icons.chat,
                'Ask questions about symptoms and treatments',
                () {
                  // TODO: Implement chat interface
                },
              ),
              buildCard(
                'Explain Your Condition',
                Icons.family_restroom,
                'Share an explainer video with loved ones',
                () {
                  // TODO: Implement condition explanation functionality
                },
              ),
              buildCard(
                'Who Are We',
                Icons.info,
                'Learn more about us',
                () {
                  // TODO: Implement about us page
                },
              ),
              buildCard(
                'Lifestyle Adjustments',
                Icons.fitness_center,
                'Tips for adapting your lifestyle',
                () {
                  // TODO: Implement lifestyle adjustments page
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                // TODO: Implement medication reminder functionality
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('Medication Reminder'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement symptoms list functionality
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('List All Known Symptoms'),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildCard(
    String title, IconData icon, String description, VoidCallback onTap) {
  return Card(
    elevation: 4,
    margin: const EdgeInsets.only(bottom: 16),
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 48, color: Colors.teal),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                // TODO: Implement information popup
              },
            ),
          ],
        ),
      ),
    ),
  );
}
