import 'package:anecdotal/utils/constants/constants.dart';
import 'package:anecdotal/views/info_view.dart';
import 'package:anecdotal/views/view_symptoms_view.dart';
import 'package:anecdotal/widgets/home_widgets/analyze_symptoms_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConfirmInformationView extends StatelessWidget {
  final String firstName;
  final String lastName;
  final List<String> symptoms;
  final String country;
  final String state;

  const ConfirmInformationView({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.symptoms,
    required this.country,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final firstNameController = TextEditingController(text: firstName);
    final lastNameController = TextEditingController(text: lastName);
    final countryController = TextEditingController(text: country);
    final stateController = TextEditingController(text: state);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Name and Last Name
            _buildTextField(
              firstNameController,
              'First Name',
              Icons.person,
            ),
            const SizedBox(height: 10),
            _buildTextField(
              lastNameController,
              'Last Name',
              Icons.person_outline,
            ),

            // Country and State
            const SizedBox(height: 20),
            _buildTextField(countryController, 'Country', Icons.flag),
            const SizedBox(height: 10),
            _buildTextField(
              stateController,
              'State',
              Icons.location_city,
            ),

            // Button to edit symptoms
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InfoView(
                      title: symptomSectionHeader,
                      sectionSummary: symptomSectionSummary,
                      firstWidget: const FirstWidgetSymptomChecker(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit/Analyze Symptoms'),
            ),

            // Display symptoms in a list format
            const SizedBox(height: 20),
            Text('Symptoms', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: symptoms.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(symptoms[index]),
                    leading: const Icon(Icons.check_circle_outline),
                  );
                },
              ),
            ),

            // Confirm & Save Button
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Save the updated info to Firestore
                  final uid = FirebaseAuth.instance.currentUser?.uid;
                  if (uid != null) {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .update({
                      'firstName': firstNameController.text,
                      'lastName': lastNameController.text,
                      'symptoms': symptoms,
                      'country': countryController.text,
                      'state': stateController.text,
                    });
                  }
                  Navigator.pop(context);
                },
                child: const Text('Confirm & Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: Icon(icon),
      ),
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
