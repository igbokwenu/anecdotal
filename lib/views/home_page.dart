import 'package:anecdotal/widgets/animated_text_home.dart';
import 'package:anecdotal/widgets/chat_input_widget.dart';
import 'package:anecdotal/widgets/custom_card_home.dart';
import 'package:anecdotal/widgets/microphone.dart';
import 'package:anecdotal/widgets/theme_toggle_button.dart';
import 'package:flutter/material.dart';

class AnecdotalAppHome extends StatelessWidget {
  const AnecdotalAppHome({super.key});

  void _showMessageDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Your Message'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Anecdotal')),
        actions: const [
          ThemeToggle(),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "This platform is built by recovered and recovering patients, with the help of compassionate medical practitioners who understand the complexities of debilitating conditions like CIRS/Mold Illness—conditions that modern medicine has yet to fully grasp. For those in search of answers and support.",
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 200,
                child: CarouselView(
                  itemExtent: 330,
                  shrinkExtent: 260,
                  elevation: 4,
                  children: [
                    buildCard(
                      'Progress Tracker',
                      Icons.track_changes,
                      'Track your daily treatments and feelings',
                      () {},
                    ),
                    buildCard(
                      'Symptom Checker',
                      Icons.health_and_safety,
                      'Tell us your symptoms, we could point you in the right direction.',
                      () {},
                    ),
                    buildCard(
                      'Home Treatments',
                      Icons.home,
                      'Pocket-friendly options for treating MARCons and Toxins',
                      () {},
                    ),
                    buildCard(
                      'Is This Making Me Sick?',
                      Icons.camera_alt,
                      'Take pictures of potential mold growth',
                      () {},
                    ),
                    buildCard(
                      'Chat with AI',
                      Icons.chat,
                      'Ask questions about symptoms and treatments',
                      () {},
                    ),
                    buildCard(
                      'Explain Your Condition',
                      Icons.family_restroom,
                      'Share an explainer video with loved ones',
                      () {},
                    ),
                    buildCard(
                      'Who Are We',
                      Icons.info,
                      'Learn more about us',
                      () {},
                    ),
                    buildCard(
                      'Lifestyle Adjustments',
                      Icons.fitness_center,
                      'Tips for adapting your lifestyle',
                      () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     ElevatedButton(
            //       onPressed: () {

            //       },
            //       child: const Text('Medication Reminder'),
            //     ),
            //     ElevatedButton(
            //       onPressed: () {

            //       },
            //       child: const Text('List All Known Symptoms'),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 80, child: AnimatedText()),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: MicrophoneIconWidget(
                size: 52.0,
                onTap: () {
                  // TODO: Implement voice input functionality
                  print('Microphone tapped');
                },
              ),
            ),
            const SizedBox(height: 10),
            ChatInputWidget(
              onSend: (message) => _showMessageDialog(context, message),
            ),
          ],
        ),
      ),
    );
  }
}
