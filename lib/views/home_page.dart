import 'package:anecdotal/services/animated_navigator.dart';
import 'package:anecdotal/utils/smaller_reusable_widgets.dart';
import 'package:anecdotal/views/basic_info_view.dart';
import 'package:anecdotal/widgets/animated_text_home.dart';
import 'package:anecdotal/widgets/chat_input_widget.dart';
import 'package:anecdotal/widgets/custom_card_home.dart';
import 'package:anecdotal/widgets/microphone.dart';
import 'package:anecdotal/widgets/test_widget.dart';
import 'package:anecdotal/widgets/theme_toggle_button.dart';
import 'package:flutter/foundation.dart';
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
        title: const Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome,
            ),
            SizedBox(width: 12),
            Text('Anecdotal'),
            // SizedBox(width: 12),
            Icon(Icons.health_and_safety),
          ],
        )),
        actions: const [
          ThemeToggle(),
          SizedBox(width: 10),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Anecdotal is built by patients, with the help of compassionate doctors - for those in search of answers and support regarding complex and debilitating chronic conditions like CIRS and Mold Illness. ",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    mySizedBox(),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          CustomCard(
                            title: 'Progress Tracker',
                            icon: Icons.track_changes,
                            description:
                                'Track your daily treatments, symptoms and feelings',
                            onTap: () {
                              Navigator.push(
                                context,
                                slideLeftTransitionPageBuilder(
                                  MedicalInfoScreen(),
                                ),
                              );
                              if (kDebugMode) {
                                print("card clicked");
                              }
                            },
                            onInfoTapped: () {
                              if (kDebugMode) {
                                print("info icon clicked");
                              }
                            },
                          ),
                          CustomCard(
                            title: 'Symptom Checker',
                            icon: Icons.health_and_safety,
                            description:
                                "Tell us your symptoms. We could point you in the right direction",
                            onTap: () {
                              Navigator.push(
                                context,
                                slideLeftTransitionPageBuilder(
                                  MedicalInfoScreen3(),
                                ),
                              );
                            },
                            onInfoTapped: () {},
                          ),
                          CustomCard(
                            title: 'Spread Awareness',
                            icon: Icons.family_restroom,
                            description:
                                'Share an explainer video with loved ones',
                            onTap: () {},
                            onInfoTapped: () {},
                          ),
                          CustomCard(
                            title: 'Chat with AI',
                            icon: Icons.chat,
                            description:
                                'Ask questions about symptoms and treatments',
                            onTap: () {},
                            onInfoTapped: () {},
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          CustomCard(
                            title: 'Home Remedies',
                            icon: Icons.home,
                            description:
                                'Pocket-friendly healing pathways to get you started',
                            onTap: () {
                              Navigator.push(
                                context,
                                slideRightTransitionPageBuilder(
                                  const TestWidget(),
                                ),
                              );
                            },
                            onInfoTapped: () {},
                          ),
                          CustomCard(
                            title: 'Investigate',
                            icon: Icons.camera_alt,
                            description:
                                'Take pictures of potential mold growth in your home',
                            onTap: () {},
                            onInfoTapped: () {},
                          ),
                          CustomCard(
                            title: 'Lifestyle',
                            icon: Icons.fitness_center,
                            description:
                                'Make helpful lifestyle adjustments to support your recovery',
                            onTap: () {},
                            onInfoTapped: () {},
                          ),
                          CustomCard(
                            title: 'Who Are We',
                            icon: Icons.info,
                            description: 'Learn more about us',
                            onTap: () {},
                            onInfoTapped: () {},
                          ),
                        ],
                      ),
                    ),
                    // Add some bottom padding to ensure content isn't covered by the stack
                    const SizedBox(height: 180),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: kIsWeb ? 80 : 20, vertical: 10.0),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 25,
                        width: 300,
                        child: AnimatedText(),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: MicrophoneIconWidget(
                      size: 42.0,
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(height: 10),
                  ChatInputWidget(
                    onSend: (message) => _showMessageDialog(context, message),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
