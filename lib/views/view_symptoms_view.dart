import 'package:anecdotal/services/animated_navigator.dart';
import 'package:anecdotal/utils/constants/constants.dart';
import 'package:anecdotal/views/symptoms_selector_view.dart';
import 'package:anecdotal/widgets/reusable_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:anecdotal/providers/user_data_provider.dart';

class SymptomsDisplay extends ConsumerWidget {
  const SymptomsDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(
        anecdotalUserDataProvider(FirebaseAuth.instance.currentUser?.uid));

    return Scaffold(
      appBar: AppBar(
        title: const MyAppBarTitleWithAI(title: 'Symptoms'),
      ),
      body: userData.when(
        data: (data) {
          if (data == null || data.symptomsList.isEmpty) {
            return const Center(child: Text('No symptoms recorded.'));
          }

          return Column(
            children: [
              Flexible(
                child: ListView.builder(
                  itemCount: data.symptomsList.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    return _buildSymptomListTile(
                        context, data.symptomsList[index], ref);
                  },
                ),
              ),

              // Add widget below the ListView
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      slideLeftTransitionPageBuilder(
                        const SymptomsSelectionPage(),
                      ),
                    );
                  },
                  label: const Text('Add Symptom'),
                  icon: const Icon(Icons.add),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildSymptomListTile(
      BuildContext context, String symptom, WidgetRef ref) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ListTile(
        title: Text(
          symptom,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteSymptom(context, symptom, ref),
        ),
      ),
    );
  }

  Future<void> _deleteSymptom(
      BuildContext context, String symptom, WidgetRef ref) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: No user found.')),
      );
      return;
    }

    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

      await userRef.update({
        userSymptomsList: FieldValue.arrayRemove([symptom]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$symptom deleted successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting $symptom: $e')),
      );
    }
  }
}
