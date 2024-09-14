import 'package:anecdotal/providers/user_data_provider.dart';
import 'package:anecdotal/services/animated_navigator.dart';
import 'package:anecdotal/utils/reusable_function.dart';
import 'package:anecdotal/views/progress_tracker_view.dart';
import 'package:anecdotal/views/visualise_progress_view.dart';
import 'package:anecdotal/widgets/reusable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirstWidgetProgressTracker extends ConsumerWidget {
  const FirstWidgetProgressTracker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userData = ref.watch(anecdotalUserDataProvider(uid)).value;
    return Column(
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
          label: const Text("Record Your Journey"),
          icon: const Icon(Icons.edit_note),
        ),
        mySpacing(),
        ElevatedButton.icon(
          label: const Text('Visualize Your Journey'),
          onPressed: () {
            userData!.healingJourneyMap.isEmpty
                ? MyReusableFunctions.myReusableCustomDialog(
                    context: context,
                    message:
                        'You have not yet recorded any progress. Click the "Record Your Journey" button and record your progress to visualize them over time.')
                : Navigator.push(
                    context,
                    slideLeftTransitionPageBuilder(
                      const VisualizeProgress(),
                    ),
                  );
          },
          icon: const Icon(Icons.bar_chart),
        ),
      ],
    );
  }
}
