import 'package:anecdotal/providers/user_data_provider.dart';
import 'package:anecdotal/services/auth_service.dart';
import 'package:anecdotal/utils/constants/constants.dart';
import 'package:anecdotal/views/edit_account_view.dart';
import 'package:anecdotal/widgets/reusable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:anecdotal/models/user_model.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userData = ref.watch(anecdotalUserDataProvider(uid));
    final AuthService authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.teal,
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
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(
                          '${user.profilePicUrl!.isEmpty ? anecdotalLogoUrl : user.profilePicUrl}'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user.email ?? 'No email provided',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 20),
                  // _buildInfoCard('Country', user.country ?? 'Not specified'),
                  // const SizedBox(height: 10),
                  _buildInfoCard('Location', user.state ?? 'Not specified'),
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
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await authService
                    .deleteUser(); // Call AuthService delete account
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacementNamed(context,
                    AppRoutes.authWrapper); // Redirect to login after delete
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
