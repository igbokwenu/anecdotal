import 'package:anecdotal/providers/button_state_providers.dart';
import 'package:anecdotal/providers/iap_provider.dart';
import 'package:anecdotal/providers/public_data_provider.dart';
import 'package:anecdotal/providers/user_data_provider.dart';
import 'package:anecdotal/services/animated_navigator.dart';
import 'package:anecdotal/services/database_service.dart';
import 'package:anecdotal/services/gemini_ai_service.dart';
import 'package:anecdotal/utils/constants/ai_prompts.dart';
import 'package:anecdotal/utils/constants/constants.dart';
import 'package:anecdotal/utils/reusable_function.dart';
import 'package:anecdotal/views/medical_history_view.dart';
import 'package:anecdotal/views/report_view.dart';
import 'package:anecdotal/views/symptoms_selector_view.dart';
import 'package:anecdotal/views/view_symptoms_view.dart';
import 'package:anecdotal/widgets/reusable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirstWidgetSymptomChecker extends ConsumerWidget {
  const FirstWidgetSymptomChecker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonLoadingState = ref.watch(chatInputProvider);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final databaseService = DatabaseService(uid: uid!);
    final userData = ref.watch(anecdotalUserDataProvider(uid)).value;
    final iapStatus = ref.watch(iapProvider);
    ref.read(iapProvider.notifier).checkAndSetIAPStatus();
    final publicData = ref.watch(publicDataProvider).value;

    Future<void> handleSend(
      BuildContext context,
    ) async {
      MyReusableFunctions.showProcessingToast();
      ref.read(chatInputProvider.notifier).setIsAnalyzing(true);
      await databaseService.incrementUsageCount(
          uid, userAiGeneralTextUsageCount);
      await databaseService.incrementUsageCount(uid, userAiTextUsageCount);
      final response = await GeminiService.sendTextPrompt(
        message: sendSymptomAnalysisPrompt(
          symptoms: "${userData!.symptomsList}",
          history: userData.medicalHistoryList.isEmpty
              ? null
              : "${userData.medicalHistoryList}",
          externalReport: forDoctor,
        ),
        apiKey: publicData!.zodiac,
        preferredModel: publicData.geminiModel,
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
              followUpSearchTerms:
                  response['suggestions']?.cast<String>() ?? [],
              citations: response['citations']?.cast<String>() ?? [],
              title: 'Symptom Analysis',
              reportType: userSymptomReportPdfUrls,
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
              : "Update Your Medical History"),
          icon: const Icon(
            Icons.health_and_safety,
          ),
        ),
        mySpacing(spacing: 12),
        if (userData.symptomsList.isNotEmpty) ...[
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                slideLeftTransitionPageBuilder(
                  const SymptomsSelectionPage(),
                ),
              );
            },
            label: const Text("Analyze Your Symptoms"),
            icon: const Icon(
              Icons.search,
            ),
          ),
          mySpacing(),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                slideLeftTransitionPageBuilder(
                  const SymptomsDisplay(),
                ),
              );
            },
            label: const Text("View Your Symptoms"),
            icon: const Icon(
              Icons.visibility,
            ),
          ),
          mySpacing(spacing: 10),
          buttonLoadingState.isAnalyzing
              ? const MySpinKitWaveSpinner()
              : ElevatedButton.icon(
                  onPressed: () async {
                    userData.aiGeneralTextUsageCount >=
                                publicData!.aiFreeUsageLimit &&
                            !iapStatus.isPro
                        ? MyReusableFunctions.showPremiumDialog(
                            context: context,
                          )
                        : await handleSend(context);
                  },
                  label: const Text("Generate A Report For Your Doctor"),
                  icon: const Icon(
                    Icons.auto_awesome,
                  ),
                ),
        ],
      ],
    );
  }
}
