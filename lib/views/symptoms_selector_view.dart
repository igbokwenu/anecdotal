import 'package:anecdotal/providers/button_state_providers.dart';
import 'package:anecdotal/providers/iap_provider.dart';
import 'package:anecdotal/providers/user_data_provider.dart';
import 'package:anecdotal/services/database_service.dart';
import 'package:anecdotal/services/gemini_ai_service.dart';
import 'package:anecdotal/utils/constants/ai_prompts.dart';
import 'package:anecdotal/utils/constants/constants.dart';
import 'package:anecdotal/utils/reusable_function.dart';
import 'package:anecdotal/utils/constants/symptom_list.dart';
import 'package:anecdotal/views/report_view.dart';
import 'package:anecdotal/widgets/reusable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SymptomsSelectionPage extends ConsumerStatefulWidget {
  const SymptomsSelectionPage({super.key});

  @override
  SymptomsSelectionPageState createState() => SymptomsSelectionPageState();
}

class SymptomsSelectionPageState extends ConsumerState<SymptomsSelectionPage> {
  // Store the selected symptoms
  Map<String, List<String>> selectedSymptoms = {};

  @override
  Widget build(BuildContext context) {
    final buttonLoadingState = ref.watch(chatInputProvider);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final databaseService = DatabaseService(uid: uid!);
    final userData = ref.watch(anecdotalUserDataProvider(uid)).value;
    List<String> alreadySelectedSymptoms = userData!.symptomsList;
    final iapStatus = ref.watch(iapProvider);
    ref.read(iapProvider.notifier).checkAndSetIAPStatus();

    // Symptoms lists by category
    Map<String, List<String>> symptoms = {
      'General/Constitutional Symptoms': generalSymptoms,
      'Neurological and Cognitive Symptoms': neurologicalSymptoms,
      'Psychiatric Symptoms': psychiatricSymptoms,
      'Eye and Vision Symptoms': eyeSymptoms,
      'Respiratory Symptoms': respiratorySymptoms,
      'Cardiovascular Symptoms': cardiovascularSymptoms,
      'Gastrointestinal Symptoms': gastrointestinalSymptoms,
      'Skin Symptoms': skinSymptoms,
      'Genitourinary Symptoms': genitourinarySymptoms,
      'Other Symptoms': otherSymptoms,
      'More Reported Symptoms': additionalCirsSymptoms,
    };

    // Filter out already selected symptoms
    symptoms = symptoms.map((category, symptomList) {
      final filteredSymptoms = symptomList
          .where((symptom) => !alreadySelectedSymptoms.contains(symptom))
          .toList();
      return MapEntry(category, filteredSymptoms);
    });

    Future<void> handleSend(
      BuildContext context,
    ) async {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final databaseService = DatabaseService(uid: uid!);

      MyReusableFunctions.showProcessingToast();
      ref.read(chatInputProvider.notifier).setIsAnalyzing(true);
      await databaseService.incrementUsageCount(
          uid, userAiGeneralTextUsageCount);
      await databaseService.incrementUsageCount(uid, userAiTextUsageCount);

      // Flatten selectedSymptoms into a list of strings
      List<String> formattedSelectedSymptoms =
          selectedSymptoms.entries.expand((entry) => entry.value).toList();

      // Merge formattedSelectedSymptoms with alreadySelectedSymptoms
      List<String> allSelectedSymptoms =
          [...alreadySelectedSymptoms, ...formattedSelectedSymptoms].toList();

      // Send allSelectedSymptoms to GeminiService
      final response = await GeminiService.sendTextPrompt(
        message: sendSymptomAnalysisPrompt(
            symptoms: "$allSelectedSymptoms",
            history: userData.medicalHistoryList.isEmpty
                ? null
                : "${userData.medicalHistoryList}"),
      );

      // Update Firestore with allSelectedSymptoms
      await databaseService.updateAnyUserData(
          fieldName: userSymptomsList, newValue: allSelectedSymptoms);

      print("Crap $allSelectedSymptoms");

      if (response != null) {
        ref.read(chatInputProvider.notifier).setIsAnalyzing(false);
        Navigator.pushReplacement(
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
              title: 'Symptom Analysis', reportType: userSymptomReportPdfUrls,
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

    return Scaffold(
      appBar: AppBar(
        title: const MyAppBarTitleWithAI(title: 'Select & Click Analyze'),
      ),
      body: ListView(
        children: [
          ...symptoms.keys.map((category) {
            return ExpansionTile(
              title: Text(category),
              children: symptoms[category]!.map((symptom) {
                return CheckboxListTile(
                  title: Text(symptom),
                  value: selectedSymptoms[category]?.contains(symptom) ?? false,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedSymptoms[category] = [
                          ...(selectedSymptoms[category] ?? []),
                          symptom
                        ];
                      } else {
                        selectedSymptoms[category]?.remove(symptom);
                      }
                    });
                  },
                );
              }).toList(),
            );
          }),
          // Fancy box to show all selected symptoms
          selectedSymptoms.isEmpty
              ? myEmptySizedBox()
              : Card(
                  margin: const EdgeInsets.all(16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selected Symptoms',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...selectedSymptoms.entries.map((entry) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ...entry.value.map((symptom) => Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Text('• $symptom'),
                                  )),
                              const SizedBox(height: 8),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
          mySpacing(spacing: 80),
        ],
      ),
      floatingActionButton: buttonLoadingState.isAnalyzing
          ? const MySpinKitWaveSpinner()
          : ElevatedButton.icon(
              onPressed:
                  selectedSymptoms.isEmpty && userData.symptomsList.isEmpty
                      ? null
                      : () async {
                          userData.aiGeneralTextUsageCount >= freeLimit &&
                                  !iapStatus.isPro
                              ? MyReusableFunctions.showPremiumDialog(
                                  context: context,
                                )
                              : await handleSend(context);
                          print(selectedSymptoms);
                        },
              label: const Text('Analyze Symptoms'),
              icon: const Icon(Icons.auto_awesome),
            ),
    );
  }
}
