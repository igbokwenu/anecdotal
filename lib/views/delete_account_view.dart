import 'package:anecdotal/services/auth_service.dart';
import 'package:anecdotal/utils/constants/constants.dart';
import 'package:anecdotal/widgets/reusable_widgets.dart';
import 'package:flutter/material.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({Key? key}) : super(key: key);

  @override
  _DeleteAccountPageState createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    // Add post-frame callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Code to be executed after the first frame
      print('First frame built!');
      _deleteAccount();
    });
  }

  Future<void> _deleteAccount() async {
    try {
      final AuthService authService = AuthService();
      await authService.deleteUser();
      await authService.signOut();

      // After successful deletion, navigate to a new route (e.g., login page)
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.onboardingWrapper, (route) => false);
      }
    } catch (e) {
      // Handle any errors here
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting account: ${e.toString()}')),
        );
        // Navigate back or to an error page
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MySpinKitWaveSpinner(
              size: 80,
            ),
            SizedBox(height: 16),
            Text(
              'Deleting account...',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
