import 'package:anecdotal/providers/button_state_providers.dart';
import 'package:anecdotal/providers/iap_provider.dart';
import 'package:anecdotal/providers/user_data_provider.dart';
import 'package:anecdotal/services/database_service.dart';
import 'package:anecdotal/services/gemini_ai_service.dart';
import 'package:anecdotal/utils/constants/ai_prompts.dart';
import 'package:anecdotal/utils/constants/constants.dart';
import 'package:anecdotal/utils/constants/writeups.dart';
import 'package:anecdotal/utils/reusable_function.dart';
import 'package:anecdotal/views/report_view.dart';
import 'package:anecdotal/widgets/reusable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class AIImageSelectWidget extends ConsumerStatefulWidget {
  final String prompt;

  final Function(Map<String, dynamic>?) onResponse;
  final bool allowFileSelect;
  final int maxImages;
  final String? selectButtonText;
  final String? analyzeButtonText;
  final bool isLabTest;
  final bool showSendToDoctor;
  final bool showSendToLandlord;
  final bool showSendToEmployer;

  const AIImageSelectWidget({
    super.key,
    required this.prompt,
    required this.onResponse,
    this.allowFileSelect = false,
    this.maxImages = 4,
    this.selectButtonText = 'Select Image',
    this.analyzeButtonText = 'Analyze Image',
    this.isLabTest = false,
    this.showSendToDoctor = true,
    this.showSendToLandlord = true,
    this.showSendToEmployer = true,
  });

  @override
  _AIImageSelectWidgetState createState() => _AIImageSelectWidgetState();
}

class _AIImageSelectWidgetState extends ConsumerState<AIImageSelectWidget> {
  final List<File> _selectedFiles = [];
  bool _isAnalyzing = false;

  Future<void> _pickImages() async {
    List<XFile>? pickedFiles;
    if (widget.allowFileSelect) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
        allowMultiple: true,
      );
      if (result != null) {
        pickedFiles = result.files.map((file) => XFile(file.path!)).toList();
      }
    } else {
      final ImagePicker picker = ImagePicker();
      pickedFiles = await picker.pickMultiImage();
    }

    if (pickedFiles != null) {
      setState(() {
        _selectedFiles.addAll(pickedFiles!
            .map((xFile) => File(xFile.path))
            .take(widget.maxImages - _selectedFiles.length));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonLoadingState = ref.watch(chatInputProvider);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final databaseService = DatabaseService(uid: uid!);
    final userData = ref.watch(anecdotalUserDataProvider(uid)).value;
    final iapStatus = ref.watch(iapProvider);
    ref.read(iapProvider.notifier).checkAndSetIAPStatus();

    Future<void> analyzeImages() async {
      if (_selectedFiles.isEmpty) return;

      setState(() {
        _isAnalyzing = true;
      });

      try {
        await databaseService.incrementUsageCount(
            uid, userAiGeneralMediaUsageCount);
        await databaseService.incrementUsageCount(uid, userAiMediaUsageCount);
        final response = await GeminiService.analyzeImages(
          images: _selectedFiles,
          prompt: widget.prompt,
        );

        widget.onResponse(response);
      } catch (e) {
        print('Error analyzing images: $e');
        widget.onResponse(null);
      } finally {
        setState(() {
          _isAnalyzing = false;
          // _selectedFiles.clear(); // Clear the selected files after analysis
        });
      }
    }

    Future<void> handleSend(
      BuildContext context,
      String forWho,
    ) async {
      if (!kIsWeb) {
        if (!iapStatus.isPro) {
          MyReusableFunctions.showPremiumDialog(
              context: context, message: premiumSpeechAnalyzeButton);
        } else {
          MyReusableFunctions.showProcessingToast();
          ref.read(chatInputProvider.notifier).setIsAnalyzing(true);
          final response = await GeminiService.analyzeImages(
            images: _selectedFiles,
            prompt: widget.isLabTest
                ? sendLabAnalysisPrompt(
                    symptoms: userData!.symptomsList.isEmpty
                        ? null
                        : "${userData.symptomsList}",
                    history: userData.medicalHistoryList.isEmpty
                        ? null
                        : "${userData.medicalHistoryList}",
                    externalReport: forWho,
                  )
                : sendHouseImageAnalysisPrompt(
                    prompt: userData!.symptomsList.isEmpty
                        ? null
                        : "Here is a previously disclosed list of symptoms experienced: ${userData.symptomsList}. And previously disclosed health history: ${userData.medicalHistoryList}",
                    externalReport: forWho,
                  ),
          );

          if (response != null) {
            ref.read(chatInputProvider.notifier).setIsAnalyzing(false);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReportView(
                  summaryContent:
                      response['summary'] ?? 'No summary available.',
                  keyInsights: response['insights']?.cast<String>() ?? [],
                  recommendations:
                      response['recommendations']?.cast<String>() ?? [],
                  followUpSearchTerms:
                      response['suggestions']?.cast<String>() ?? [],
                  citations: response['citations']?.cast<String>() ?? [],
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
      }
    }

    return Column(
      children: [
        if (_selectedFiles.isEmpty) ...[
          mySpacing(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              "Use the Select Image button below if you want the option of generating a report you can send to your Doctor, Employer or Landlord/Property Manager.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
        mySpacing(spacing: 16),
        ElevatedButton.icon(
          onPressed: _pickImages,
          label: Text(widget.allowFileSelect
              ? 'Select Files'
              : widget.selectButtonText!),
          icon: const Icon(Icons.attach_file),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Only images are currently supported. We are working towards adding support for uploading documents.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        if (_selectedFiles.isNotEmpty) ...[
          // mySpacing(spacing: 8),
          widget.allowFileSelect
              ? const Text(
                  "Can't show preview, click button below to analyze selected files.",
                  textAlign: TextAlign.center,
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedFiles
                      .map((file) => Image.file(file,
                          width: 100, height: 100, fit: BoxFit.cover))
                      .toList(),
                ),
        ],
        mySpacing(spacing: 16),
        ElevatedButton.icon(
          onPressed: _selectedFiles.isEmpty || _isAnalyzing
              ? null
              : () async {
                  userData!.aiGeneralMediaUsageCount >= freeLimit &&
                          !iapStatus.isPro
                      ? MyReusableFunctions.showPremiumDialog(
                          context: context,)
                      : await analyzeImages();
                },
          label: _isAnalyzing
              ? const MySpinKitWaveSpinner(size: 40)
              : Text(widget.allowFileSelect
                  ? 'Analyze Files'
                  : widget.analyzeButtonText!),
          icon: const Icon(Icons.auto_awesome),
        ),
        buttonLoadingState.isAnalyzing
            ? const MySpinKitWaveSpinner()
            : Column(
                children: [
                  if (widget.showSendToDoctor) ...[
                    mySpacing(),
                    ElevatedButton.icon(
                      onPressed: _selectedFiles.isEmpty
                          ? null
                          : () {
                              handleSend(context, forDoctor);
                            },
                      label: const Text("Generate Report For Your Doctor"),
                      icon: const Icon(
                        Icons.auto_awesome,
                      ),
                    ),
                  ],
                  if (widget.showSendToLandlord) ...[
                    mySpacing(),
                    ElevatedButton.icon(
                      onPressed: _selectedFiles.isEmpty
                          ? null
                          : () {
                              handleSend(context, forLandlord);
                            },
                      label: const Text("Generate Report For Your Landlord"),
                      icon: const Icon(
                        Icons.auto_awesome,
                      ),
                    ),
                  ],
                  if (widget.showSendToEmployer) ...[
                    mySpacing(),
                    ElevatedButton.icon(
                      onPressed: _selectedFiles.isEmpty
                          ? null
                          : () {
                              handleSend(context, forEmployer);
                            },
                      label: const Text("Generate Report For Your Employer"),
                      icon: const Icon(
                        Icons.auto_awesome,
                      ),
                    ),
                  ],
                ],
              )
      ],
    );
  }
}
