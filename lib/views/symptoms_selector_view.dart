import 'package:anecdotal/utils/symptom_list.dart';
import 'package:flutter/material.dart';

class SymptomsSelectionPage extends StatefulWidget {
  const SymptomsSelectionPage({super.key});

  @override
  SymptomsSelectionPageState createState() => SymptomsSelectionPageState();
}

class SymptomsSelectionPageState extends State<SymptomsSelectionPage> {
  // Store the selected symptoms
  Map<String, List<String>> selectedSymptoms = {};

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Symptoms'),
      ),
      body: ListView(
        children: symptoms.keys.map((category) {
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
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Process selected symptoms
          print(selectedSymptoms);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}

