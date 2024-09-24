import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    final _symptomsController = TextEditingController(text: symptoms.join(', '));
    final _countryController = TextEditingController(text: country);
    final _stateController = TextEditingController(text: state);

    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: _symptomsController,
              decoration: InputDecoration(labelText: 'Symptoms'),
            ),
            TextField(
              controller: _countryController,
              decoration: InputDecoration(labelText: 'Country'),
            ),
            TextField(
              controller: _stateController,
              decoration: InputDecoration(labelText: 'State'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Save the updated info to Firestore
                final uid = FirebaseAuth.instance.currentUser?.uid;
                if (uid != null) {
                  await FirebaseFirestore.instance.collection('users').doc(uid).update({
                    'firstName': _firstNameController.text,
                    'lastName': _lastNameController.text,
                    'symptoms': _symptomsController.text.split(', '),
                    'country': _countryController.text,
                    'state': _stateController.text,
                  });
                }
                Navigator.pop(context);
              },
              child: Text('Confirm & Save'),
            ),
          ],
        ),
      ),
    );
  }
}
