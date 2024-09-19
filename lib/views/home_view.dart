import 'package:anecdotal/providers/user_data_provider.dart';
import 'package:anecdotal/services/database_service.dart';
import 'package:anecdotal/utils/reusable_function.dart';
import 'package:anecdotal/views/view_widgets.dart/home_rectangular_card_view.dart';
import 'package:anecdotal/views/view_widgets.dart/home_square_card_widget.dart';
import 'package:anecdotal/widgets/custom_drawer.dart';
import 'package:anecdotal/widgets/home_widgets/analyze_symptoms_widget.dart';
import 'package:anecdotal/widgets/home_widgets/first_interpret_lab_widget.dart';
import 'package:anecdotal/widgets/home_widgets/first_investigate_home.dart';
import 'package:anecdotal/widgets/home_widgets/progress_tracker_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

import 'dart:io';
import 'package:anecdotal/providers/button_state_providers.dart';
import 'package:anecdotal/services/animated_navigator.dart';
import 'package:anecdotal/services/gemini_ai_service.dart';
import 'package:anecdotal/utils/constants/ai_prompts.dart';
import 'package:anecdotal/utils/constants/constants.dart';
import 'package:anecdotal/widgets/reusable_widgets.dart';
import 'package:anecdotal/views/info_view.dart';
import 'package:anecdotal/views/report_view.dart';
import 'package:anecdotal/widgets/animated_text_home.dart';
import 'package:anecdotal/widgets/chat_input_widget.dart';
import 'package:anecdotal/widgets/custom_card_home.dart';
import 'package:anecdotal/widgets/theme_toggle_button.dart';
import 'package:anecdotal/widgets/voice_recorder_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void initState() {
    super.initState();
    _checkFirstSeen();
  }

  Future<void> _checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (!_seen) {
      await prefs.setBool('seen', true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // ignore: prefer_const_constructors
        MyReusableFunctions.showCustomDialog(
          context: context,
          message:
              'Welcome to Anecdotal AI! We\'re here to support you on your health journey. Take the first step towards healing by sharing your symptoms.',
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Later'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  slideLeftTransitionPageBuilder(
                    InfoView(
                      title: symptomSectionHeader,
                      sectionSummary: symptomSectionSummary,
                      firstWidget: const FirstWidgetSymptomChecker(),
                    ),
                  ),
                );
              },
              child: const Text('Analyze Your Symptoms'),
            ),
          ],
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatInputState = ref.watch(chatInputProvider);
    final theme = Theme.of(context);
    final uid = FirebaseAuth.instance.currentUser?.uid;

    final databaseService = DatabaseService(uid: uid!);

    final userData = ref.watch(anecdotalUserDataProvider(uid)).value;

    Future<void> handleAudioStop(String path) async {
      ref.read(chatInputProvider.notifier).setIsProcessingAudio(true);
      ref.read(chatInputProvider.notifier).setIsListeningToAudio(false);
      try {
        final response = await GeminiService.analyzeAudioForHome(
          audios: [File(path)],
          prompt: sendChatPrompt(
              prompt: userData!.symptomsList.isEmpty
                  ? null
                  : "Here are symptoms the user says they are having: ${userData.symptomsList}. And some details on their medical history: ${userData.medicalHistoryList}"),
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
                followUpSearchTerms:
                    response['suggestions']?.cast<String>() ?? [],
                citations: response['citations']?.cast<String>() ?? [],
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

    Future<void> handleSend(BuildContext context, String message) async {
      final response = await GeminiService.sendTextPrompt(
        message: sendChatPrompt(
            prompt:
                "$message Here are symptoms the user says they are having: ${userData!.symptomsList}. And some details on their medical history: ${userData.medicalHistoryList}"),
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
              followUpSearchTerms:
                  response['suggestions']?.cast<String>() ?? [],
              citations: response['citations']?.cast<String>() ?? [],
            ),
          ),
        );
      } else {
        _showMessageDialog(context, "No response received.");
        print("No response received.");
      }
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     TextButton(
                      //       onPressed: () async {

                      //       },
                      //       child: Text('Open '),
                      //     ),
                      //   ],
                      // ),
                      mySpacing(spacing: 3),
                      ImageContainer(
                        imagePath: logoAssetImageUrlNoTagLine,
                        title: 'Symptom Checker',
                        subtitle: 'Let us help analyze your symptoms',
                        onTap: () {
                          Navigator.push(
                            context,
                            slideLeftTransitionPageBuilder(
                              InfoView(
                                title: symptomSectionHeader,
                                sectionSummary: symptomSectionSummary,
                                firstWidget: const FirstWidgetSymptomChecker(),
                              ),
                            ),
                          );
                        },
                      ),
                      // Square container
                      Row(
                        children: [
                          ImageContainer(
                            imagePath: logoAssetImageUrlWithTagLine,
                            title: 'Investigate',
                            subtitle: 'Is your home making you sick?',
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
                                        : const FirstWidgetInvestigateHome(),
                                  ),
                                ),
                              );
                            },
                            isSquare: true,
                            width: MediaQuery.of(context).size.width / 2 - 16,
                            height: MediaQuery.of(context).size.width / 2 - 16,
                          ),
                          ImageContainer(
                            imagePath: logoAssetImageUrlWithTagLine,
                            title: 'Interpret Lab',
                            subtitle: 'Understand your lab results.',
                            onTap: () {
                              Navigator.push(
                                context,
                                slideLeftTransitionPageBuilder(
                                  InfoView(
                                    title: interpretLabResultSectionHeader,
                                    sectionSummary:
                                        interpretLabResultSectionSummary,
                                    firstWidget: kIsWeb
                                        ? const Text(
                                            "Image capture and upload not currently supported on web. Please use the Anecdotal mobile app.",
                                            textAlign: TextAlign.center,
                                          )
                                        : const FirstWidgetInterpretLab(),
                                  ),
                                ),
                              );
                            },
                            isSquare: true,
                            width: MediaQuery.of(context).size.width / 2 - 16,
                            height: MediaQuery.of(context).size.width / 2 - 16,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          ImageContainer(
                            imagePath: logoAssetImageUrlWithTagLine,
                            title: 'Track Progress',
                            subtitle: 'Find patterns in your healing journey.',
                            onTap: () {
                              Navigator.push(
                                context,
                                slideLeftTransitionPageBuilder(
                                  InfoView(
                                    title: progressTrackerSectionHeader,
                                    sectionSummary:
                                        progressTrackerSectionSummary,
                                    firstWidget:
                                        const FirstWidgetProgressTracker(),
                                  ),
                                ),
                              );
                            },
                            isSquare: true,
                            width: MediaQuery.of(context).size.width / 2 - 16,
                            height: MediaQuery.of(context).size.width / 2 - 16,
                          ),
                          ImageContainer(
                            imagePath: logoAssetImageUrlWithTagLine,
                            title: 'About Us',
                            subtitle: 'What is our mission and vision?',
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.about);
                            },
                            isSquare: true,
                            width: MediaQuery.of(context).size.width / 2 - 16,
                            height: MediaQuery.of(context).size.width / 2 - 16,
                          ),
                        ],
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
                            onSend: (message) async {
                              await handleSend(context, message);
                            },
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
}
