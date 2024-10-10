import 'package:anecdotal/providers/user_data_provider.dart';
import 'package:anecdotal/services/animated_navigator.dart';
import 'package:anecdotal/services/database_service.dart';
import 'package:anecdotal/utils/constants/constants.dart';
import 'package:anecdotal/utils/constants/symptom_list.dart';
import 'package:anecdotal/views/symptoms_selector_view.dart';
import 'package:anecdotal/widgets/reusable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExposureHistoryScreen extends ConsumerStatefulWidget {
  const ExposureHistoryScreen({super.key});

  @override
  _ExposureHistoryScreenState createState() => _ExposureHistoryScreenState();
}

class _ExposureHistoryScreenState extends ConsumerState<ExposureHistoryScreen> {
  final List<Map<String, dynamic>> userResponses = [];
  int currentQuestionIndex = 0;
  List<String> selectedConditions = [];

  void _resetQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      userResponses.clear();
      selectedConditions.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final databaseService = DatabaseService(uid: uid!);
    final userData = ref.watch(anecdotalUserDataProvider(uid)).value;

    void showResultsDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Your Answers'),
            content: SizedBox(
              height: 300,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: userResponses
                      .map((response) => ListTile(
                            title: Text(response['question']!),
                            subtitle: Text('Answer: ${response['answer']}'),
                          ))
                      .toList(),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _resetQuiz();
                },
                child: const Text('Retake Test'),
              ),
              TextButton(
                onPressed: () async {
                  List<String> formattedResponses = userResponses
                      .map((response) =>
                          "${response['question']} ${response['answer']}")
                      .toList();
                  await databaseService.updateAnyUserData(
                      fieldName: userMedicalHistoryList,
                      newValue: formattedResponses);
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    slideLeftTransitionPageBuilder(
                      const SymptomsSelectionPage(),
                    ),
                  );
                },
                child: const Text('Analyze Symptoms'),
              ),
            ],
          );
        },
      );
    }

    void handleAnswer(dynamic answer) {
      String currentQuestion = exposureHistory[currentQuestionIndex];
      userResponses.add({'question': currentQuestion, 'answer': answer});

      if (currentQuestionIndex < exposureHistory.length - 1) {
        setState(() {
          currentQuestionIndex++;
        });
      } else {
        print("$userResponses");
        showResultsDialog();
      }
    }

    Widget buildQuestion() {
      if (currentQuestionIndex == exposureHistory.length - 1) {
        return Column(
          children: [
            Text(
              "Select any conditions you have been diagnosed with:",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ...potentialMisdiagnosisList.map((condition) {
              return CheckboxListTile(
                title: Text(condition),
                value: selectedConditions.contains(condition),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      selectedConditions.add(condition);
                    } else {
                      selectedConditions.remove(condition);
                    }
                  });
                },
              );
            }).toList(),
            ElevatedButton(
              onPressed: () {
                handleAnswer(selectedConditions.isEmpty
                    ? "None"
                    : selectedConditions.join(", "));
              },
              child: const Text('Submit'),
            ),
          ],
        );
      } else {
        return Column(
          children: [
            Text(
              exposureHistory[currentQuestionIndex],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => handleAnswer('Yes'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    'Yes',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => handleAnswer('No'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    backgroundColor: Colors.red,
                  ),
                  child: const Text(
                    'No',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ],
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const MyAppBarTitleWithAI(
          title: "Exposure History",
        ),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildQuestion(),
                const SizedBox(height: 20),
                Text(
                  'Question ${currentQuestionIndex + 1} of ${exposureHistory.length}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
