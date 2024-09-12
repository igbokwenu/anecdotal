import 'package:anecdotal/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:anecdotal/providers/user_data_provider.dart';

class SymptomsDisplay extends ConsumerWidget {
  const SymptomsDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(
        anecdotalUserDataProvider(FirebaseAuth.instance.currentUser?.uid));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Symptoms'),
      ),
      body: userData.when(
        data: (data) {
          if (data == null || data.symptomsList.isEmpty) {
            return const Center(child: Text('No symptoms recorded.'));
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                // Grid layout for larger screens
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: data.symptomsList.length,
                  padding: const EdgeInsets.all(20),
                  itemBuilder: (context, index) {
                    return _buildSymptomCard(context, data.symptomsList[index]);
                  },
                );
              } else {
                // List layout for smaller screens
                return ListView.builder(
                  itemCount: data.symptomsList.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    return _buildSymptomListTile(
                        context, data.symptomsList[index], ref);
                  },
                );
              }
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildSymptomCard(BuildContext context, String symptom) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.7)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              symptom,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: () => _deleteSymptom(context, symptom),
            ),
          ],
        ),
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
            color: Theme.of(context).textTheme.displayLarge!.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteSymptom(context, symptom),
        ),
      ),
    );
  }

  Future<void> _deleteSymptom(BuildContext context, String symptom) async {
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
        userSymptomsList : FieldValue.arrayRemove([symptom]),
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
