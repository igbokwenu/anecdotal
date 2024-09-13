import 'package:anecdotal/providers/user_data_provider.dart';
import 'package:anecdotal/services/animated_navigator.dart';
import 'package:anecdotal/utils/constants/ai_prompts.dart';
import 'package:anecdotal/views/report_view.dart';
import 'package:anecdotal/widgets/camera_ai.dart';
import 'package:anecdotal/widgets/image_select_ai.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirstWidgetInterpretLab extends ConsumerWidget {
  const FirstWidgetInterpretLab({super.key});

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
                CameraWidget(
                  prompt: sendLabAnalysisPrompt(
                      symptoms: userData!.symptomsList.isEmpty
                          ? null
                          : "${userData.symptomsList}",
                      history: userData.medicalHistoryList.isEmpty
                          ? null
                          : "${userData.medicalHistoryList}"),
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
          label: const Text("Capture Report"),
          icon: const Icon(Icons.camera_alt),
        ),
        AIImageSelectWidget(
          isLabTest: true,
          // showSendToLandlord: false,
          // showSendToEmployer: false,
          prompt: sendLabAnalysisPrompt(
              symptoms: userData!.symptomsList.isEmpty
                  ? null
                  : "${userData.symptomsList}",
              history: userData.medicalHistoryList.isEmpty
                  ? null
                  : "${userData.medicalHistoryList}"),
          // allowFileSelect: true,
          selectButtonText: 'Select Report Image',
          analyzeButtonText: 'Analyze Report',
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
      ],
    );
  }
}
