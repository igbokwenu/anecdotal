import 'package:anecdotal/views/view_symptoms_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConfirmInformationView extends StatelessWidget {
  final String firstName;
  final String lastName;
  final List<String> symptoms;
  final String country;
  final String state;

  ConfirmInformationView({
    required this.firstName,
    required this.lastName,
    required this.symptoms,
    required this.country,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final _firstNameController = TextEditingController(text: firstName);
    final _lastNameController = TextEditingController(text: lastName);
    final _countryController = TextEditingController(text: country);
    final _stateController = TextEditingController(text: state);

    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Name and Last Name
            _buildTextField(
              _firstNameController,
              'First Name',
              Icons.person,
            ),
            SizedBox(height: 10),
            _buildTextField(
              _lastNameController,
              'Last Name',
              Icons.person_outline,
            ),

            // Country and State
            SizedBox(height: 20),
            _buildTextField(_countryController, 'Country', Icons.flag),
            SizedBox(height: 10),
            _buildTextField(
              _stateController,
              'State',
              Icons.location_city,
            ),

            // Button to edit symptoms
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SymptomsDisplay(),
                  ),
                );
              },
              icon: Icon(Icons.edit),
              label: Text('Edit/Analyze Symptoms'),
            ),

            // Display symptoms in a list format
            SizedBox(height: 20),
            Text('Symptoms', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: symptoms.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(symptoms[index]),
                    leading: Icon(Icons.check_circle_outline),
                  );
                },
              ),
            ),

            // Confirm & Save Button
            SizedBox(height: 20),
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
                      'firstName': _firstNameController.text,
                      'lastName': _lastNameController.text,
                      'symptoms': symptoms,
                      'country': _countryController.text,
                      'state': _stateController.text,
                    });
                  }
                  Navigator.pop(context);
                },
                child: Text('Confirm & Save'),
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
    );
  }
}
