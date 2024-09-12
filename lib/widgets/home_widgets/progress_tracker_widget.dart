import 'package:anecdotal/services/animated_navigator.dart';
import 'package:anecdotal/views/progress_tracker_view.dart';
import 'package:flutter/material.dart';

class FirstWidgetProgressTracker extends StatelessWidget {
  const FirstWidgetProgressTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
                                        children: [
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                slideLeftTransitionPageBuilder(
                                                  const ProgressTracker(),
                                                ),
                                              );
                                            },
                                            label: const Text(
                                                "Track Your Progress"),
                                            icon: const Icon(Icons.timeline),
                                          ),
                                        ],
                                      );
  }
}