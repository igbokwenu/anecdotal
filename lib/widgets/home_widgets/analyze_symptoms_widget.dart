import 'package:anecdotal/providers/user_data_provider.dart';
import 'package:anecdotal/services/animated_navigator.dart';
import 'package:anecdotal/views/medical_history_view.dart';
import 'package:anecdotal/views/symptoms_selector_view.dart';
import 'package:anecdotal/widgets/smaller_reusable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeAnalyzeSymptomsWidget extends ConsumerWidget {
  const HomeAnalyzeSymptomsWidget({super.key});

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
                const ExposureHistoryScreen(),
              ),
            );
          },
          label: Text(userData!.medicalHistoryList.isEmpty
              ? "Tell Us A Bit About Your History"
              : "Update Your Health History"),
          icon: const Icon(
            Icons.health_and_safety,
          ),
        ),
        mySpacing(),
        userData.symptomsList.isEmpty
            ? myEmptySizedBox()
            : ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    slideLeftTransitionPageBuilder(
                      const SymptomsSelectionPage(),
                    ),
                  );
                },
                label: const Text("Update & Investigate Your Symptoms"),
                icon: const Icon(
                  Icons.search,
                ),
              ),
      ],
    );
  }
}
