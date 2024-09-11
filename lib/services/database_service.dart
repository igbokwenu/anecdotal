import 'package:anecdotal/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

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
      userHealingJourneyMap: {},
    });
  }
}

