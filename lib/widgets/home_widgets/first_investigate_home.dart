import 'package:anecdotal/providers/button_state_providers.dart';
import 'package:anecdotal/providers/user_data_provider.dart';
import 'package:anecdotal/services/animated_navigator.dart';
import 'package:anecdotal/services/gemini_ai_service.dart';
import 'package:anecdotal/utils/ai_prompts.dart';
import 'package:anecdotal/utils/reusable_function.dart';
import 'package:anecdotal/views/report_view.dart';
import 'package:anecdotal/widgets/camera_ai.dart';
import 'package:anecdotal/widgets/image_select_ai.dart';
import 'package:anecdotal/widgets/smaller_reusable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirstWidgetInvestigateHome extends ConsumerWidget {
  const FirstWidgetInvestigateHome({super.key});

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
                CameraWidget(
                  prompt: sendHouseImageAnalysisPrompt(
                      prompt: userData!.symptomsList.isEmpty
                          ? null
                          : "Here are symptoms the user previously reported experiencing : ${userData.symptomsList}. And some details from their previously shared medical/exposure history: ${userData.medicalHistoryList}"),
                  onResponse: (result) {
                    if (result != null) {
                      Navigator.pushReplacement(
                        context,
                        slideLeftTransitionPageBuilder(
                          ReportView(
                            summaryContent:
                                result['summary'] ?? 'No summary available.',
                            keyInsights:
                                result['insights']?.cast<String>() ?? [],
                            recommendations:
                                result['recommendations']?.cast<String>() ?? [],
                            followUpSuggestions:
                                result['suggestions']?.cast<String>() ?? [],
                          ),
                        ),
                      );
                      print("Summary: ${result['summary']}");
                      print("Insights: ${result['insights']}");
                      print("Recommendations: ${result['recommendations']}");
                      print("Suggestions: ${result['suggestions']}");
                    } else {
                      print("Analysis failed or returned no results");
                    }
                  },
                  onComplete: () {},
                ),
              ),
            );
          },
          label: const Text("Capture Your Surrounding"),
          icon: const Icon(Icons.camera_alt),
        ),
        AIImageSelectWidget(
          prompt: sendHouseImageAnalysisPrompt(
              prompt: userData!.symptomsList.isEmpty
                  ? null
                  : "Here are symptoms the user previously reported experiencing : ${userData.symptomsList}. And some details from their previously shared medical/exposure history: ${userData.medicalHistoryList}"),
          // allowFileSelect: false,
          maxImages: 4,
          onResponse: (result) {
            if (result != null) {
              Navigator.push(
                context,
                slideLeftTransitionPageBuilder(
                  ReportView(
                    summaryContent:
                        result['summary'] ?? 'No summary available.',
                    keyInsights: result['insights']?.cast<String>() ?? [],
                    recommendations:
                        result['recommendations']?.cast<String>() ?? [],
                    followUpSuggestions:
                        result['suggestions']?.cast<String>() ?? [],
                  ),
                ),
              );
              print("Summary: ${result['summary']}");
              print("Insights: ${result['insights']}");
              print("Recommendations: ${result['recommendations']}");
              print("Suggestions: ${result['suggestions']}");
            } else {
              print("Analysis failed or returned no results.");
            }
          },
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
        ],
      ],
    );
  }
}
