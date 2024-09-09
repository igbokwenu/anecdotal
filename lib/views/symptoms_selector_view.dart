import 'package:anecdotal/utils/symptom_list.dart';
import 'package:flutter/material.dart';

class SymptomsSelectionPage extends StatefulWidget {
  @override
  _SymptomsSelectionPageState createState() => _SymptomsSelectionPageState();
}

class _SymptomsSelectionPageState extends State<SymptomsSelectionPage> {
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
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Symptoms'),
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
        child: Icon(Icons.check),
      ),
    );
  }
}

class CIRSSymptomsSelector extends StatefulWidget {
  @override
  _CIRSSymptomsSelectorState createState() => _CIRSSymptomsSelectorState();
}

class _CIRSSymptomsSelectorState extends State<CIRSSymptomsSelector> {
  List<Map<String, dynamic>> _categories = cirsSymptomCategories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CIRS Symptoms Selector'),
      ),
      body: SingleChildScrollView(
        child: ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _categories[index]['isExpanded'] = !isExpanded;
            });
          },
          children: _categories.map<ExpansionPanel>((Map<String, dynamic> category) {
            return ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(category['category']),
                );
              },
              body: Column(
                children: (category['symptoms'] as List<String>).map((symptom) {
                  return CheckboxListTile(
                    title: Text(symptom),
                    value: category['selectedSymptoms']?.contains(symptom) ?? false,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          category['selectedSymptoms'] ??= [];
                          category['selectedSymptoms'].add(symptom);
                        } else {
                          category['selectedSymptoms']?.remove(symptom);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              isExpanded: category['isExpanded'] ?? false,
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Here you can process the selected symptoms
          List<String> selectedSymptoms = [];
          for (var category in _categories) {
            if (category['selectedSymptoms'] != null) {
              selectedSymptoms.addAll(category['selectedSymptoms']);
            }
          }
          print('Selected symptoms: $selectedSymptoms');
        },
        child: Icon(Icons.check),
        tooltip: 'Submit selected symptoms',
      ),
    );
  }
}