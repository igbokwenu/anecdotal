import 'dart:io';

import 'package:anecdotal/providers/button_state_providers.dart';
import 'package:anecdotal/providers/user_data_provider.dart';
import 'package:anecdotal/services/auth_service.dart';
import 'package:anecdotal/services/gemini_ai_service.dart';
import 'package:anecdotal/utils/constants/constants.dart';
import 'package:anecdotal/utils/constants/methods.dart';
import 'package:anecdotal/utils/constants/symptom_list.dart';
import 'package:anecdotal/views/edit_account_view.dart';
import 'package:anecdotal/views/confirm_info_view.dart';
import 'package:anecdotal/widgets/reusable_widgets.dart';
import 'package:anecdotal/widgets/voice_recorder_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userData = ref.watch(anecdotalUserDataProvider(uid));
    final AuthService authService = AuthService();
    final chatInputState = ref.watch(chatInputProvider);

    Future<void> handleAudioStop(String path) async {
      ref.read(chatInputProvider.notifier).setIsProcessingAudio(true);
      ref.read(chatInputProvider.notifier).setIsListeningToAudio(false);

      try {
        final response = await GeminiService.analyzeAudioForSignup(
            audios: [File(path)],
            prompt:
                "Extract user's first name, last name and symptoms. When extracting symptoms, strictly list as many symptoms from the provided list that specifically aligns with any symptoms the user stated. If the user did not share any symptoms, do not return any item from the list. Provided list: $allCirsSymptom");

        if (response != null) {
          final firstName = response['firstName'] ?? '';
          final lastName = response['lastName'] ?? '';

          // Safely check if 'symptoms' exists and is a List
          List<String> symptoms = [];
          if (response['symptoms'] is List) {
            symptoms = (response['symptoms'] as List)
                .whereType<String>() // Ensure all items are Strings
                .toList();
          }

          List<String> filteredSymptoms =
              filterSymptoms(symptoms, allCirsSymptom);

          // Save to Firestore
          final uid = FirebaseAuth.instance.currentUser?.uid;
          if (uid != null) {
            final userDoc =
                FirebaseFirestore.instance.collection('users').doc(uid);
            await userDoc.set({
              'firstName': firstName,
              'lastName': lastName,
              'symptoms': FieldValue.arrayUnion(filteredSymptoms),
            }, SetOptions(merge: true));
          }

          // Navigate to confirm information view
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConfirmInformationView(
                firstName: firstName.isNotEmpty
                    ? firstName
                    : userData.value!.firstName!,
                lastName:
                    lastName.isNotEmpty ? lastName : userData.value!.lastName!,
                symptoms: filteredSymptoms.isNotEmpty
                    ? filteredSymptoms
                    : userData.value!.symptomsList,
                country: userData.value!.country!,
                state: userData.value!.state!,
              ),
            ),
          );
        } else {
          _showMessageDialog(context, "No information was extracted.");
        }
      } catch (e) {
        ref.read(chatInputProvider.notifier).setIsProcessingAudio(false);
        _showMessageDialog(context, "Error: $e");
      } finally {
        ref.read(chatInputProvider.notifier).setIsProcessingAudio(false);
        File(path).delete();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: userData.when(
        data: (user) {
          if (user == null) return const Center(child: Text('User not found'));

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                      child: CachedCircleAvatar(
                    imageUrl: user.profilePicUrl ?? '',
                    radius: 80,
                    fallbackUrl: anecdotalMascot2Url,
                  )),
                  const SizedBox(height: 6),

                  if (chatInputState.isListeningToAudio)
                    const MyAnimatedText(
                        text:
                            "Introduce yourself and tell us about your health history andy symptoms you are experiencing (if any). \nPress stop when you are done speaking"),
                  if (!chatInputState.isListeningToAudio)
                    if (!chatInputState.isProcessingAudio)
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.auto_awesome),
                          SizedBox(
                            width: 10,
                          ),
                          MyAnimatedText(
                              text: "Click mic to use our AI account set-up"),
                        ],
                      ),
                  chatInputState.isProcessingAudio
                      ? const MySpinKitWaveSpinner()
                      : Recorder(
                          onStop: handleAudioStop,
                          onStart: () {
                            ref
                                .read(chatInputProvider.notifier)
                                .setIsListeningToAudio(true);
                          },
                        ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100),
                    child: Divider(),
                  ),
                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${user.email!.isEmpty ? 'No email provided' : user.email}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 20),
                  // _buildInfoCard('Country', user.country ?? 'Not specified'),
                  // const SizedBox(height: 10),
                  _buildInfoCard('Location', '${user.state}, ${user.country}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserProfileEditScreen(),
                        ),
                      ).then(
                          (_) => ref.refresh(anecdotalUserDataProvider(uid)));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (authService.isUserAnonymous())
                    Column(
                      children: [
                        Text(
                          'You are signed in anonymously. When you sign out, your account and data will be permanently deleted. To preserve your data you can click the (Link Account) button below to link your data to your login credentials.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        mySpacing(),
                        _buildLinkAccountButton(context),
                      ],
                    ),
                  const SizedBox(height: 20),
                  _buildDeleteAccountButton(context),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  void _showMessageDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Icon(Icons.info_outline_rounded),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Build "View Reports" button
  Widget _buildLinkAccountButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Navigate to report page
          Navigator.pushNamed(context, AppRoutes.signUp);
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16.0),
          backgroundColor: Colors.green,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text(
          'Link Account',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.pin_drop_rounded),
          Text(' $title: ',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildDeleteAccountButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          _showDeleteConfirmationDialog(context);
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(16.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          side: const BorderSide(color: Colors.red),
        ),
        child: const Text(
          'Delete Account',
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
      ),
    );
  }

  // Show confirmation dialog before deleting account
  void _showDeleteConfirmationDialog(BuildContext context) {
    final AuthService authService = AuthService();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
              'Are you sure you want to delete your account? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await authService.deleteUser();
                await authService.signOut();
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, AppRoutes.authWrapper);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, // Button color
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
