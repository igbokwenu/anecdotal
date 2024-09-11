import 'package:anecdotal/utils/reusable_function.dart';
import 'package:anecdotal/views/medical_history_view.dart';
import 'package:anecdotal/views/symptoms_selector_view.dart';
import 'package:anecdotal/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

import 'dart:io';
import 'package:anecdotal/providers/button_state_providers.dart';
import 'package:anecdotal/services/animated_navigator.dart';
import 'package:anecdotal/services/gemini_ai_service.dart';
import 'package:anecdotal/utils/ai_prompts.dart';
import 'package:anecdotal/utils/constants.dart';
import 'package:anecdotal/widgets/camera_ai.dart';
import 'package:anecdotal/widgets/image_select_ai.dart';
import 'package:anecdotal/widgets/smaller_reusable_widgets.dart';
import 'package:anecdotal/views/info_view.dart';
import 'package:anecdotal/views/report_view.dart';
import 'package:anecdotal/widgets/animated_text_home.dart';
import 'package:anecdotal/widgets/chat_input_widget.dart';
import 'package:anecdotal/widgets/custom_card_home.dart';
import 'package:anecdotal/widgets/theme_toggle_button.dart';
import 'package:anecdotal/widgets/voice_recorder_widget.dart';
import 'package:flutter/foundation.dart';

class AnecdotalAppHome extends ConsumerStatefulWidget {
  const AnecdotalAppHome({super.key});

  @override
  _AnecdotalAppHomeState createState() => _AnecdotalAppHomeState();
}

class _AnecdotalAppHomeState extends ConsumerState<AnecdotalAppHome> {
  final _advancedDrawerController = AdvancedDrawerController();

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final chatInputState = ref.watch(chatInputProvider);
    final theme = Theme.of(context);

    Future<void> handleAudioStop(String path) async {
      ref.read(chatInputProvider.notifier).setIsProcessingAudio(true);
      ref.read(chatInputProvider.notifier).setIsListeningToAudio(false);
      try {
        final response = await GeminiService.analyzeAudioForHome(
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

    // Get the screen size using MediaQuery.sizeOf or MediaQuery.of(context).size
    final Size screenSize = MediaQuery.sizeOf(context);
    // final bool isMobile = screenSize.width < 600;
    final bool isTabletOrDesktop = screenSize.width >= 600;
    // final bool isLandscape = screenSize.width > screenSize.height;

    return AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.primaryColor,
              theme.secondaryHeaderColor,
              theme.primaryColor.withOpacity(0.2)
            ],
          ),
        ),
      ),
      openRatio: isTabletOrDesktop ? 0.35 : 0.65,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: CustomDrawer(controller: _advancedDrawerController),
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_awesome),
                SizedBox(width: 12),
                Text('Anecdotal'),
                Icon(Icons.health_and_safety),
              ],
            ),
          ),
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                  ),
                );
              },
            ),
          ),
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
                      //  Row(
                      // children: [
                      // TextButton(
                      //   onPressed: () {
                      //     Navigator.push(
                      //       context,
                      //       slideLeftTransitionPageBuilder(
                      //         DownloadPage(),
                      //       ),
                      //     );
                      //   },
                      //   child: Text('Meta'),
                      // ),
                      // TextButton(
                      //   onPressed: () {
                      //     Navigator.push(
                      //       context,
                      //       slideLeftTransitionPageBuilder(
                      //         const DownloadPage(),
                      //       ),
                      //     );
                      //   },
                      //   child: const Text('Claude'),
                      // ),
                      // TextButton(
                      //   onPressed: () {
                      //     Navigator.push(
                      //       context,
                      //       slideLeftTransitionPageBuilder(
                      //         DownloadView(),
                      //       ),
                      //     );
                      //   },
                      //   child: Text('Open'),
                      // ),
                      //  ],
                      // ),
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
                                      firstWidget: Column(
                                        children: [
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                slideLeftTransitionPageBuilder(
                                                  ExposureHistoryScreen(),
                                                ),
                                              );
                                            },
                                            label: const Text(
                                                "Tell Us A Bit About Your History"),
                                            icon: const Icon(
                                              Icons.health_and_safety,
                                            ),
                                          ),
                                          mySpacing(),
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                slideLeftTransitionPageBuilder(
                                                  const SymptomsSelectionPage(),
                                                ),
                                              );
                                            },
                                            label: const Text(
                                                "Investigate Your Symptoms"),
                                            icon: const Icon(
                                              Icons.search,
                                            ),
                                          ),
                                        ],
                                      ),
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
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
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
                                      firstWidget: kIsWeb
                                          ? const Text(
                                              "Image capture and upload not currently supported on web. Please use the Anecdotal mobile app.",
                                              textAlign: TextAlign.center,
                                            )
                                          : Column(
                                              children: [
                                                ElevatedButton.icon(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      slideLeftTransitionPageBuilder(
                                                        CameraWidget(
                                                          prompt:
                                                              sendHouseImageAnalysisPrompt,
                                                          onResponse: (result) {
                                                            if (result !=
                                                                null) {
                                                              Navigator
                                                                  .pushReplacement(
                                                                context,
                                                                slideLeftTransitionPageBuilder(
                                                                  ReportView(
                                                                    summaryContent:
                                                                        result['summary'] ??
                                                                            'No summary available.',
                                                                    keyInsights:
                                                                        result['insights']?.cast<String>() ??
                                                                            [],
                                                                    recommendations:
                                                                        result['recommendations']?.cast<String>() ??
                                                                            [],
                                                                    followUpSuggestions:
                                                                        result['suggestions']?.cast<String>() ??
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
                                                          onComplete: () {},
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  label: const Text(
                                                      "Capture Your Surrounding"),
                                                  icon: const Icon(
                                                      Icons.camera_alt),
                                                ),
                                                AIImageSelectWidget(
                                                  prompt:
                                                      sendHouseImageAnalysisPrompt,
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
                                                          "Analysis failed or returned no results.");
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
                              title: 'Interpret Lab',
                              icon: Icons.biotech_rounded,
                              description:
                                  'Get a preliminary assessment of your lab results',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  slideLeftTransitionPageBuilder(
                                    InfoView(
                                      title: interpretLabResultSectionHeader,
                                      sectionSummary:
                                          interpretLabResultSectionSummary,
                                      firstWidget: Column(
                                        children: [
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                slideLeftTransitionPageBuilder(
                                                  CameraWidget(
                                                    prompt:
                                                        sendLabAnalysisPrompt(),
                                                    onResponse: (result) {
                                                      if (result != null) {
                                                        Navigator
                                                            .pushReplacement(
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
                                                    onComplete: () {},
                                                  ),
                                                ),
                                              );
                                            },
                                            label: const Text("Capture Report"),
                                            icon: const Icon(Icons.camera_alt),
                                          ),
                                          AIImageSelectWidget(
                                            prompt: sendLabAnalysisPrompt(),
                                            // allowFileSelect: true,
                                            selectButtonText:
                                                'Select Report Image',
                                            analyzeButtonText: 'Analyze Report',
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
                                                              ?.cast<
                                                                  String>() ??
                                                          [],
                                                      recommendations: result[
                                                                  'recommendations']
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
                                                    "Analysis failed or returned no results.");
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
                                  context,
                                  interpretLabResultSectionSummary,
                                );
                              },
                            ),
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
                                      sectionSummary:
                                          homeRemediesSectionSummary,
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
                              title: 'Lifestyle',
                              icon: Icons.fitness_center,
                              description:
                                  'Make helpful lifestyle adjustments to support your recovery',
                              onTap: () {
                                MyReusableFunctions.showCustomToast(
                                    description: "Coming Soon. Stay Tuned.");
                              },
                              onInfoTapped: () {},
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
      ),
    );
  }

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
}
