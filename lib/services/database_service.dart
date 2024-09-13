import 'package:anecdotal/utils/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addToHealingJourneyMap(Map<String, dynamic> newEntry) async {
    final userRef = userCollection.doc(uid);

    // Using Firestore's FieldValue.arrayUnion to append new data to the existing map field
    await userRef.update({
      userHealingJourneyMap: FieldValue.arrayUnion([newEntry]),
    }).catchError((e) {
      print('Error updating healing journey: $e');
    });
  }

  Future<void> updateAnyUserData(
      {required String fieldName, required dynamic newValue}) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

    // Get the current data
    final currentData = (await userRef.get()).data();

    if (currentData != null) {
      // Update the specified field with the new value
      currentData[fieldName] = newValue;

      // Update the document with the modified data
      await userRef.update(currentData);
    } else {
      // Handle the case where currentData is null (document not found)
      print('Document with ID $uid not found.');
    }
  }

  Future<void> updateUserDocument(Map<String, dynamic> userData) async {
    return await userCollection.doc(uid).set(userData);
  }

  Future<void> createUserDocument() async {
    return await updateUserDocument({
      userFirstName: '',
      userLastName: '',
      userCountry: '',
      userState: '',
      userEmail: '',
      userProfilePicUrl: '',
      userSymptomsList: [],
      userToDoList: [],
      userInProgressList: [],
      userDoneList: [],
      userSymptomAnalysis: '',
      userHomeAnalysis: '',
      userProgressAnalysis: '',
      userProgressList: [],
      userUserStoryList: [],
      userIsDiagnosed: false,
      userIsMedicalProfessional: false,
      userIsAdmin: false,
      userIsBanned: false,
      userIsSuperAdmin: false,
      userIsPro: false,
      userOtherSymptomsList: [],
      userUid: uid,
      userHomeReportImageUrls: [],
      userLabReportImageUrls: [],
      userSymptomReportImageUrls: [],
      userHomeReportPdfUrls: [],
      userLabReportPdfUrls: [],
      userSymptomReportPdfUrls: [],
      userMedicalHistoryList: [],
      userAiMediaUsageCount: 0,
      userAiTextUsageCount: 0,
      userAiGeneralMediaUsageCount: 0,
      userAiGeneralTextUsageCount: 0,
      userHealingJourneyMap: [],
    });
  }
}
