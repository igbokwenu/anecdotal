import 'package:anecdotal/providers/button_state_providers.dart';
import 'package:anecdotal/providers/user_data_provider.dart';
import 'package:anecdotal/services/animated_navigator.dart';
import 'package:anecdotal/services/gemini_ai_service.dart';
import 'package:anecdotal/utils/ai_prompts.dart';
import 'package:anecdotal/utils/reusable_function.dart';
import 'package:anecdotal/views/medical_history_view.dart';
import 'package:anecdotal/views/report_view.dart';
import 'package:anecdotal/views/symptoms_selector_view.dart';
import 'package:anecdotal/widgets/smaller_reusable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirstWidgetSymptomChecker extends ConsumerWidget {
  const FirstWidgetSymptomChecker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonLoadingState = ref.watch(chatInputProvider);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userData = ref.watch(anecdotalUserDataProvider(uid)).value;
    Future<void> handleSend(
      BuildContext context,
    ) async {
      MyReusableFunctions.showProcessingToast();
      ref.read(chatInputProvider.notifier).setIsAnalyzing(true);
      final response = await GeminiService.sendTextPrompt(
        message: sendSymptomAnalysisPrompt(
          symptoms: "${userData!.symptomsList}",
          history: userData.medicalHistoryList.isEmpty
              ? null
              : "${userData.medicalHistoryList}",
          externalReport: forDoctor,
        ),
      );

      if (response != null) {
        ref.read(chatInputProvider.notifier).setIsAnalyzing(false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReportView(
              summaryContent: response['summary'] ?? 'No summary available.',
              keyInsights: response['insights']?.cast<String>() ?? [],
              recommendations:
                  response['recommendations']?.cast<String>() ?? [],
              followUpSuggestions:
                  response['suggestions']?.cast<String>() ?? [],
              title: 'Symptom Analysis',
            ),
          ),
        );
      } else {
        ref.read(chatInputProvider.notifier).setIsAnalyzing(false);
        MyReusableFunctions.showCustomToast(
            description: "No response received.");
        print("No response received.");
      }
    }

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
        mySpacing(spacing: 12),
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
        if (userData.symptomsList.isNotEmpty) ...[
          mySpacing(spacing: 20),
          buttonLoadingState.isAnalyzing
              ? const MySpinKitWaveSpinner()
              : ElevatedButton.icon(
                  onPressed: () {
                    handleSend(context);
                  },
                  label: Text("Generate A Report For Your Doctor"),
                  icon: const Icon(
                    Icons.auto_awesome,
                  ),
                ),
        ]
      ],
    );
  }
}
