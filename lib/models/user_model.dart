import 'package:anecdotal/utils/constants/constants.dart';

class AnecdotalUserData {
  final String? uid;
  final String? firstName;
  final String? lastName;
  final String? country;
  final String? state;
  final String? email;
  final String? profilePicUrl;
  final List<String> symptomsList;
  final List<String> toDoList;
  final List<String> inProgressList;
  final List<String> doneList;
  final List<String> deletedTasks;
  final String? symptomAnalysis;
  final String? homeAnalysis;
  final String? progressAnalysis;
  final List<String> progressList;
  final List<String> userStoryList;
  final bool isDiagnosed;
  final bool isMedicalProfessional;
  final bool isAdmin;
  final bool isBanned;
  final bool isSuperAdmin;
  final bool isPro;
  final List<String> otherSymptomsList;
  final List<String> homeReportImageUrls;
  final List<String> labReportImageUrls;
  final List<String> symptomReportImageUrls;
  final List<String> homeReportPdfUrls;
  final List<String> labReportPdfUrls;
  final List<String> symptomReportPdfUrls;
  final List<String> medicalHistoryList;
  final int aiMediaUsageCount;
  final int aiTextUsageCount;
  final int aiGeneralMediaUsageCount;
  final int aiGeneralTextUsageCount;
 final List<Map<String, dynamic>> healingJourneyMap;

  AnecdotalUserData({
    this.uid,
    this.firstName,
    this.lastName,
    this.country,
    this.state,
    this.email,
    this.profilePicUrl,
    this.symptomsList = const [],
    this.toDoList = const [],
    this.inProgressList = const [],
    this.doneList = const [],
    this.deletedTasks = const [],
    this.symptomAnalysis,
    this.homeAnalysis,
    this.progressAnalysis,
    this.progressList = const [],
    this.userStoryList = const [],
    this.isDiagnosed = false,
    this.isMedicalProfessional = false,
    this.isAdmin = false,
    this.isBanned = false,
    this.isSuperAdmin = false,
    this.isPro = false,
    this.otherSymptomsList = const [],
    this.homeReportImageUrls = const [],
    this.labReportImageUrls = const [],
    this.symptomReportImageUrls = const [],
    this.homeReportPdfUrls = const [],
    this.labReportPdfUrls = const [],
    this.symptomReportPdfUrls = const [],
    this.medicalHistoryList = const [],
    this.aiMediaUsageCount = 0,
    this.aiTextUsageCount = 0,
    this.aiGeneralMediaUsageCount = 0,
    this.aiGeneralTextUsageCount = 0,
   this.healingJourneyMap = const [],
  });

  factory AnecdotalUserData.fromMap(Map<String, dynamic>? data) {
    return AnecdotalUserData(
      uid: data?[userUid],
      firstName: data?[userFirstName],
      lastName: data?[userLastName],
      country: data?[userCountry],
      state: data?[userState],
      email: data?[userEmail],
      profilePicUrl: data?[userProfilePicUrl],
      symptomsList: List<String>.from(data?[userSymptomsList] ?? []),
      toDoList: List<String>.from(data?[userToDoList] ?? []),
      inProgressList: List<String>.from(data?[userInProgressList] ?? []),
      doneList: List<String>.from(data?[userDoneList] ?? []),
      deletedTasks: List<String>.from(data?[userDeletedTasksList] ?? []),
      symptomAnalysis: data?[userSymptomAnalysis],
      homeAnalysis: data?[userHomeAnalysis],
      progressAnalysis: data?[userProgressAnalysis],
      progressList: List<String>.from(data?[userProgressList] ?? []),
      userStoryList: List<String>.from(data?[userUserStoryList] ?? []),
      isDiagnosed: data?[userIsDiagnosed] ?? false,
      isMedicalProfessional: data?[userIsMedicalProfessional] ?? false,
      isAdmin: data?[userIsAdmin] ?? false,
      isBanned: data?[userIsBanned] ?? false,
      isSuperAdmin: data?[userIsSuperAdmin] ?? false,
      isPro: data?[userIsPro] ?? false,
      otherSymptomsList: List<String>.from(data?[userOtherSymptomsList] ?? []),
      homeReportImageUrls:
          List<String>.from(data?[userHomeReportImageUrls] ?? []),
      labReportImageUrls:
          List<String>.from(data?[userLabReportImageUrls] ?? []),
      symptomReportImageUrls:
          List<String>.from(data?[userSymptomReportImageUrls] ?? []),
      homeReportPdfUrls: List<String>.from(data?[userHomeReportPdfUrls] ?? []),
      labReportPdfUrls: List<String>.from(data?[userLabReportPdfUrls] ?? []),
      symptomReportPdfUrls:
          List<String>.from(data?[userSymptomReportPdfUrls] ?? []),
      medicalHistoryList:
          List<String>.from(data?[userMedicalHistoryList] ?? []),
      aiMediaUsageCount: data?[userAiMediaUsageCount] ?? 0,
      aiTextUsageCount: data?[userAiTextUsageCount] ?? 0,
      aiGeneralMediaUsageCount: data?[userAiGeneralMediaUsageCount] ?? 0,
      aiGeneralTextUsageCount: data?[userAiGeneralTextUsageCount] ?? 0,
        healingJourneyMap: List<Map<String, dynamic>>.from(data?[userHealingJourneyMap] ?? []),
    );
  }
}
