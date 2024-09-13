import 'package:anecdotal/providers/user_data_provider.dart';
import 'package:anecdotal/services/animated_navigator.dart';
import 'package:anecdotal/utils/constants/ai_prompts.dart';
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
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userData = ref.watch(anecdotalUserDataProvider(uid)).value;
    return Column(
      children: [
        const NoSymptomsSharedButton(),
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
                            followUpSearchTerms:
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
                : "Here are symptoms the user previously reported experiencing : ${userData.symptomsList}. And some details from their previously shared medical/exposure history: ${userData.medicalHistoryList}",
          ),
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
                    followUpSearchTerms:
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
