import 'package:anecdotal/services/animated_navigator.dart';
import 'package:anecdotal/utils/symptom_list.dart';
import 'package:anecdotal/views/symptoms_selector_view.dart';
import 'package:anecdotal/widgets/smaller_reusable_widgets.dart';
import 'package:flutter/material.dart';

class ExposureHistoryScreen extends StatefulWidget {
  @override
  _ExposureHistoryScreenState createState() => _ExposureHistoryScreenState();
}

class _ExposureHistoryScreenState extends State<ExposureHistoryScreen> {
  // List to store the user's answers
  final List<Map<String, String>> userResponses = [];

  int currentQuestionIndex = 0;

  // Function to handle user's answer and move to next question
  void _handleAnswer(String answer) {
    String currentQuestion = exposureHistory[currentQuestionIndex];
    userResponses.add({'question': currentQuestion, 'answer': answer});

    if (currentQuestionIndex < exposureHistory.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      print("$userResponses");
      _showResultsDialog();
    }
  }

  // Show the results dialog with all responses
  void _showResultsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Your Answers'),
          content: SizedBox(
            height: 300, // Limit the height for scrolling
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
                // _resetQuiz();
                Navigator.pushReplacement(
                  context,
                  slideLeftTransitionPageBuilder(
                    const SymptomsSelectionPage(),
                  ),
                );
              },
              child: Text('Analyze Symptoms'),
            ),
          ],
        );
      },
    );
  }

  // Reset the questionnaire
  void _resetQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      userResponses.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MyAppBarTitleWithAI(
          title: "Exposure History",
        ),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              exposureHistory[currentQuestionIndex],
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _handleAnswer('Yes'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    backgroundColor: Colors.green,
                  ),
                  child: Text(
                    'Yes',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _handleAnswer('No'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    backgroundColor: Colors.red,
                  ),
                  child: Text(
                    'No',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Question ${currentQuestionIndex + 1} of ${exposureHistory.length}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
