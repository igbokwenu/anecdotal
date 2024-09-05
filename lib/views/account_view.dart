import 'package:anecdotal/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:anecdotal/services/auth_service.dart';

class AccountPage extends StatelessWidget {
  final AuthService _authService = AuthService();
  User? user = FirebaseAuth.instance.currentUser;
  AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            const SizedBox(height: 20),
            _buildDetailSection(),
            const SizedBox(height: 20),
            _buildReportCardButton(context),
            const SizedBox(height: 20),
            _buildDeleteAccountButton(context),
          ],
        ),
      ),
    );
  }

  // Build profile picture and basic info
  Widget _buildProfileSection() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(
              'https://via.placeholder.com/150'), // Placeholder for profile picture
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'John Doe', // Replace with real data
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? 'john.doe@anonymous.com', // Replace with real data
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  // Build account details section
  Widget _buildDetailSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location: New York, USA', // Replace with real data
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 10),
        Divider(),
      ],
    );
  }

  // Build "View Reports" button
  Widget _buildReportCardButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Navigate to report page
          Navigator.pushNamed(context, '/viewReports');
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text(
          'View Reports',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  // Build "Delete Account" button
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
                await _authService
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
