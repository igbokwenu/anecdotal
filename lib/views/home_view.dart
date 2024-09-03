import 'dart:io';

import 'package:anecdotal/providers/button_state_providers.dart';
import 'package:anecdotal/services/animated_navigator.dart';
import 'package:anecdotal/services/gemini_ai_service.dart';
import 'package:anecdotal/utils/ai_prompts.dart';
import 'package:anecdotal/utils/constants.dart';
import 'package:anecdotal/views/about_view.dart';
import 'package:anecdotal/widgets/camera_ai.dart';
import 'package:anecdotal/widgets/camera_gpt.dart';
import 'package:anecdotal/widgets/image_select_ai.dart';
import 'package:anecdotal/widgets/smaller_reusable_widgets.dart';
import 'package:anecdotal/views/info_view.dart';
import 'package:anecdotal/views/report_view.dart';
import 'package:anecdotal/widgets/animated_text_home.dart';
import 'package:anecdotal/widgets/chat_input_widget.dart';
import 'package:anecdotal/widgets/custom_card_home.dart';
import 'package:anecdotal/widgets/test_widget.dart';
import 'package:anecdotal/widgets/theme_toggle_button.dart';
import 'package:anecdotal/widgets/voice_recorder_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnecdotalAppHome extends ConsumerWidget {
  const AnecdotalAppHome({super.key});

  void _showMessageDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Icon(Icons.info_outline_rounded),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
          ),
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

  Future<void> _handleSend(BuildContext context, String message) async {
    final response = await GeminiService.sendTextPrompt(
      message: sendChatPrompt(prompt: message),
    );

    if (response != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReportView(
            summaryContent: response['summary'] ?? 'No summary available.',
            keyInsights: response['insights']?.cast<String>() ?? [],
            recommendations: response['recommendations']?.cast<String>() ?? [],
            followUpSuggestions: response['suggestions']?.cast<String>() ?? [],
          ),
        ),
      );
    } else {
      _showMessageDialog(context, "No response received.");
      print("No response received.");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatInputState = ref.watch(chatInputProvider);

    Future<void> handleAudioStop(String path) async {
      ref.read(chatInputProvider.notifier).setIsProcessingAudio(true);
      ref.read(chatInputProvider.notifier).setIsListeningToAudio(false);
      try {
        final response = await GeminiService.analyzeAudio(
          audios: [File(path)],
          prompt: sendChatPrompt(),
        );

        if (response != null) {
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
              ),
            ),
          );
        } else {
          _showMessageDialog(context, "No response received.");
          print("No response received.");
        }
      } catch (e) {
        _showMessageDialog(context, "Error: $e");
      } finally {
        ref.read(chatInputProvider.notifier).setIsProcessingAudio(false);
        // setState(() {
        //   _isLoading = false;
        // });
      }

      // Clean up the audio file
      File(path).delete();
    }

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
                            onTap: () async {
                              Navigator.push(
                                context,
                                slideLeftTransitionPageBuilder(
                                  InfoView(
                                    title: progressTrackerSectionHeader,
                                    sectionSummary:
                                        progressTrackerSectionSummary,
                                  ),
                                ),
                              );
                            },
                            onInfoTapped: () {
                              _showMessageDialog(
                                context,
                                progressTrackerSectionSummary,
                              );
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
                                  InfoView(
                                    title: symptomSectionHeader,
                                    sectionSummary: symptomSectionSummary,
                                  ),
                                ),
                              );
                            },
                            onInfoTapped: () {
                              _showMessageDialog(
                                  context, symptomSectionSummary);
                            },
                          ),
                          CustomCard(
                            title: 'Spread Awareness',
                            icon: Icons.family_restroom,
                            description:
                                'Share an explainer video with loved ones',
                            onTap: () {
                              Navigator.push(
                                context,
                                slideLeftTransitionPageBuilder(
                                  InfoView(
                                    title: spreadAwarenessSectionHeader,
                                    sectionSummary:
                                        spreadAwarenessSectionSummary,
                                  ),
                                ),
                              );
                            },
                            onInfoTapped: () {
                              _showMessageDialog(
                                  context, spreadAwarenessSectionSummary);
                            },
                          ),
                          CustomCard(
                            title: 'Find a Doctor',
                            icon: Icons.location_on,
                            description:
                                'Find a CIRS trained doctor in your area',
                            onTap: () {
                              Navigator.push(
                                context,
                                slideLeftTransitionPageBuilder(
                                  InfoView(
                                    title: findDoctorSectionHeader,
                                    sectionSummary: findDoctorSectionSummary,
                                  ),
                                ),
                              );
                            },
                            onInfoTapped: () {
                              _showMessageDialog(
                                  context, findDoctorSectionSummary);
                            },
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
                                slideLeftTransitionPageBuilder(
                                  InfoView(
                                    title: homeRemediesSectionHeader,
                                    sectionSummary: homeRemediesSectionSummary,
                                  ),
                                ),
                              );
                            },
                            onInfoTapped: () {
                              _showMessageDialog(
                                context,
                                homeRemediesSectionSummary,
                              );
                            },
                          ),
                          CustomCard(
                            title: 'Investigate',
                            icon: Icons.camera_alt,
                            description:
                                'Take pictures of potential mold growth in your home',
                            onTap: () {
                              Navigator.push(
                                context,
                                slideLeftTransitionPageBuilder(
                                  InfoView(
                                    title: investigateSectionHeader,
                                    sectionSummary: investigateSectionSummary,
                                    firstWidget: Column(
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              slideLeftTransitionPageBuilder(
                                                AICameraWidget(
                                                  prompt:
                                                      sendHouseImageAnalysisPrompt,
                                                  onAnalysisComplete: (result) {
                                                    if (result != null) {
                                                      Navigator.push(
                                                        context,
                                                        slideLeftTransitionPageBuilder(
                                                          ReportView(
                                                            summaryContent: result[
                                                                    'summary'] ??
                                                                'No summary available.',
                                                            keyInsights: result[
                                                                        'insights']
                                                                    ?.cast<
                                                                        String>() ??
                                                                [],
                                                            recommendations:
                                                                result['recommendations']
                                                                        ?.cast<
                                                                            String>() ??
                                                                    [],
                                                            followUpSuggestions:
                                                                result['suggestions']
                                                                        ?.cast<
                                                                            String>() ??
                                                                    [],
                                                          ),
                                                        ),
                                                      );
                                                      print(
                                                          "Summary: ${result['summary']}");
                                                      print(
                                                          "Insights: ${result['insights']}");
                                                      print(
                                                          "Recommendations: ${result['recommendations']}");
                                                      print(
                                                          "Suggestions: ${result['suggestions']}");
                                                    } else {
                                                      print(
                                                          "Analysis failed or returned no results");
                                                    }
                                                  },
                                                  enableFlash: true,
                                                  enableZoom: true,
                                                  preferredModel:
                                                      geminiProModel, // Optional
                                                ),
                                              ),
                                            );
                                          },
                                          label:
                                              Text("Capture your surrounding"),
                                          icon: Icon(Icons.camera),
                                        ),
                                        AIImageSelectWidget(
                                          prompt: sendHouseImageAnalysisPrompt,
                                          // allowFileSelect: false,
                                          maxImages: 4,
                                          onResponse: (result) {
                                            if (result != null) {
                                              Navigator.push(
                                                context,
                                                slideLeftTransitionPageBuilder(
                                                  ReportView(
                                                    summaryContent: result[
                                                            'summary'] ??
                                                        'No summary available.',
                                                    keyInsights: result[
                                                                'insights']
                                                            ?.cast<String>() ??
                                                        [],
                                                    recommendations:
                                                        result['recommendations']
                                                                ?.cast<
                                                                    String>() ??
                                                            [],
                                                    followUpSuggestions: result[
                                                                'suggestions']
                                                            ?.cast<String>() ??
                                                        [],
                                                  ),
                                                ),
                                              );
                                              print(
                                                  "Summary: ${result['summary']}");
                                              print(
                                                  "Insights: ${result['insights']}");
                                              print(
                                                  "Recommendations: ${result['recommendations']}");
                                              print(
                                                  "Suggestions: ${result['suggestions']}");
                                            } else {
                                              print(
                                                  "Analysis failed or returned no results");
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            onInfoTapped: () {
                              _showMessageDialog(
                                  context, investigateSectionSummary);
                            },
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
                            onTap: () {
                              Navigator.push(
                                context,
                                slideLeftTransitionPageBuilder(
                                  const AboutPage(),
                                ),
                              );
                            },
                            onInfoTapped: () {
                              Navigator.push(
                                context,
                                slideLeftTransitionPageBuilder(
                                  const AboutPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
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
                  horizontal: kIsWeb ? 80 : 20, vertical: 5.0),
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
                  chatInputState.isListeningToAudio
                      ? const MyAnimatedText(
                          text: "Press stop when you are done speaking")
                      : chatInputState.isProcessingAudio
                          ? const MyAnimatedText2()
                          : chatInputState.isSending
                              ? const MyAnimatedText2()
                              : const SizedBox(
                                  height: 22,
                                  width: 300,
                                  child: AnimatedText(),
                                ),
                  chatInputState.isSending
                      ? myEmptySizedBox()
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: chatInputState.isProcessingAudio
                              ? const MySpinKitWaveSpinner()
                              : Recorder(
                                  onStop: handleAudioStop,
                                  onStart: () {
                                    ref
                                        .read(chatInputProvider.notifier)
                                        .setIsListeningToAudio(true);
                                  },
                                ),
                        ),
                  const SizedBox(height: 10),
                  chatInputState.isProcessingAudio
                      ? myEmptySizedBox()
                      : ChatInputWidget(
                          onSend: (message) => _handleSend(context, message),
                        ),
                  mySpacing(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
