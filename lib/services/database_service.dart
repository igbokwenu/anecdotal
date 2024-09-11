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

class DatabaseService2 {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Create a new user document
  Future<void> createUserDocument(
    String firstName,
    String lastName,
    String countryString,
    String stateString,
    String email,
    List<String> symptoms,
    List<String> todo,
    String symptomAnalysis,
    String homeAnalysis,
    String progressAnalysis,
    int progress,
    Map<String, dynamic> userStory,
    bool isDiagnosed,
    bool isMedicalProfessional,
    bool isPro,
    String otherSymptoms,
  ) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'countryString': countryString,
        'stateString': stateString,
        'email': email,
        'symptoms': symptoms,
        'todo': todo,
        'symptomAnalysis': symptomAnalysis,
        'homeAnalysis': homeAnalysis,
        'progressAnalysis': progressAnalysis,
        'progress': progress,
        'userStory': userStory,
        'isDiagnosed': isDiagnosed,
        'isMedicalProfessional': isMedicalProfessional,
        'isPro': isPro,
        'otherSymptoms': otherSymptoms,
        'uid': user.uid,
      });
    }
  }

  // Update user document
  Future<void> updateUserDocument(
    String firstName,
    String lastName,
    String countryString,
    String stateString,
    List<String> symptoms,
    List<String> todo,
    String symptomAnalysis,
    String homeAnalysis,
    String progressAnalysis,
    int progress,
    Map<String, dynamic> userStory,
    bool isDiagnosed,
    bool isMedicalProfessional,
    bool isPro,
    String otherSymptoms,
  ) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'firstName': firstName,
        'lastName': lastName,
        'countryString': countryString,
        'stateString': stateString,
        'symptoms': symptoms,
        'todo': todo,
        'symptomAnalysis': symptomAnalysis,
        'homeAnalysis': homeAnalysis,
        'progressAnalysis': progressAnalysis,
        'progress': progress,
        'userStory': userStory,
        'isDiagnosed': isDiagnosed,
        'isMedicalProfessional': isMedicalProfessional,
        'isPro': isPro,
        'otherSymptoms': otherSymptoms,
      });
    }
  }

  // Get user document
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDocument() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return await _firestore.collection('users').doc(user.uid).get();
    } else {
      throw Exception('User is not signed in');
    }
  }
}
