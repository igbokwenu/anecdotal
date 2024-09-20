import 'package:anecdotal/providers/user_data_provider.dart';
import 'package:anecdotal/utils/constants/constants.dart';
import 'package:anecdotal/widgets/reusable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:anecdotal/models/user_model.dart';

class UserProfileEditScreen extends ConsumerStatefulWidget {
  const UserProfileEditScreen({
    super.key,
  });

  @override
  _UserProfileEditScreenState createState() => _UserProfileEditScreenState();
}

class _UserProfileEditScreenState extends ConsumerState<UserProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _countryController;
  late TextEditingController _stateController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _countryController = TextEditingController();
    _stateController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userData = ref.watch(anecdotalUserDataProvider(uid));

    Future<void> _updateUserData() async {
      if (_formKey.currentState!.validate()) {
        try {
          // Add this to debug
          print('Updating country: ${_countryController.text}');

          await FirebaseFirestore.instance.collection('users').doc(uid).update({
            'firstName': _firstNameController.text,
            'lastName': _lastNameController.text,
            'country': _countryController.text,
            'state': _stateController.text,
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
          Navigator.pop(context); // Return to the view screen
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating profile: $e')),
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.teal,
      ),
      body: userData.when(
        data: (user) {
          if (user == null) return const Center(child: Text('User not found'));

          _firstNameController.text = user.firstName ?? '';
          _lastNameController.text = user.lastName ?? '';
          _countryController.text = user.country ?? '';
          _stateController.text = user.state ?? '';

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Center(
                      child:
                          MyCircularImage(imageUrl: logoAssetImageUrlNoTagLine),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // TextFormField(
                    //   controller: _countryController,
                    //   decoration: InputDecoration(
                    //     labelText: 'Country',
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //     prefixIcon: const Icon(Icons.flag),
                    //     suffixIcon: IconButton(
                    //       icon: const Icon(Icons.arrow_drop_down),
                    //       onPressed: () {
                    //         showCountryPicker(
                    //           context: context,
                    //           showPhoneCode: false,
                    //           onSelect: (Country country) {
                    //             setState(() {
                    //               _countryController.text = country.name;
                    //             });
                    //             print(
                    //                 'Selected country: ${country.displayName}');
                    //           },
                    //         );
                    //       },
                    //     ),
                    //   ),
                    //   readOnly: true,
                    //   onTap: () {
                    //     showCountryPicker(
                    //       context: context,
                    //       showPhoneCode: false,
                    //       onSelect: (Country country) {
                    //         setState(() {
                    //           _countryController.text = country.name;
                    //         });
                    //         print('Selected country: ${country.displayName}');
                    //       },
                    //     );
                    //   },
                    // ),
                    // const SizedBox(height: 16),
                    TextFormField(
                      controller: _stateController,
                      decoration: InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.location_city),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: _updateUserData,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Update Profile',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
