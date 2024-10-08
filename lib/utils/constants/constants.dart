//Gemini models documentation:https://ai.google.dev/models/gemini
const String geminiFlashModel = 'gemini-1.5-flash';
const String geminiProModel = 'gemini-1.5-pro';
const String gpt4OModel = "gpt-4o";
const String gpt4OMiniModel = "gpt-4o-mini";

//Home Section
String symptomSectionHeader = "Analyze Your Symptoms";
String symptomSectionSummary =
    "Discover if your symptoms might be related to mycotoxins or bio-toxins. Simply answer a few questions and select the symptoms that apply to you - and we will provide some insights. \n\nStart by clicking the button below and telling us a bit about yourself.";

String progressTrackerSectionHeader = "Track Your Progress";
String progressTrackerSectionSummary =
    """Record how your well-being evolves over time. By logging your daily or weekly activities and progress, you can gain a clearer understanding of how effective your treatments or lifestyle changes have been. 
    
Consistent tracking allows our AI tool to provide insightful summaries of your wellness journey, or you can dive deeper by chatting with your personal history to gain tailored insights.""";

String investigateSectionHeader = "Investigate Your Space";
String investigateSectionSummary =
    "Learn more about how your surroundings might be contributing to your condition. This section helps you identify potential environmental triggers like mold, dampness, or other harmful factors that could be affecting your health. Investigate and take steps to create a safer living space. You can either capture your surrounding using the camera or upload and analyze images for a specialized AI powered image analysis on potential toxins that could make you sick.";

String homeRemediesSectionHeader = "Explore Home Remedies";
String homeRemediesSectionSummary =
    "Discover natural and practical remedies you can try at home to alleviate symptoms of CIRS. From dietary adjustments to lifestyle changes, this section offers tips and advice to help you manage your condition in a non-invasive way.";

String findDoctorSectionHeader = "Find a Specialist";
String findDoctorSectionSummary =
    "If you're seeking professional help, this section connects you with doctors who specialize in treating mold illness and related conditions. Get recommendations and guidance on how to find the right healthcare provider to support your recovery.";

String spreadAwarenessSectionHeader = "Spread Awareness";
String spreadAwarenessSectionSummary =
    "Help raise awareness about Chronic Inflammatory Response Syndrome and mold illness. This section provides resources and information that you can share with others, empowering your community to recognize and address this often-overlooked health issue.";

String interpretLabResultSectionHeader = "Lab Result";
String interpretLabResultSectionSummary =
    "Understand your test results with confidence! This section offers clear explanations and expert insights to help you understand your lab results, empowering you to take informed action towards your recovery. This could be lab reports from testing your home from toxins etc. We will do our best to tell which lab results might be tied to the symptoms you are experiencing.  \n\nPlease note that this is not a replacement or substitute for professional medical interpretation of the report.";

class AppRoutes {
  static const String authWrapper = '/authWrapper';
  static const String signUp = '/sign_up';
  static const String passwordRecovery = '/password_recovery';
  // static const String home = '/home';
  static const String about = '/about';
  static const String privacy = '/privacy';
  static const String terms = '/terms';
  static const String account = '/account';
  static const String download = '/download';
  static const String onboardingWrapper = '/';
}

const String logoAssetImageUrlCircular = "assets/images/logo_circular.png";
const String logoAssetImageUrlCircularWithTag =
    "assets/images/anecdotal_rounded_tag.png";
const String logoAssetImageUrlNoTagLine = "assets/images/logo_512x512.png";
const String logoAssetImageUrlOnlyLogo =
    "assets/images/anecdotal_only_logo.png";
const String logoAssetImageUrlWithTagLine =
    "assets/images/anecdotal_logo_tag_2000.png";

const logoAssetImageUrlSplash = 'assets/images/logo_splash.png';

//revenuecat keys
const googleApiKey = 'goog_vsEPEYPdkWRUGqBiNyaGMjSqHbt';
const appleApiKey = 'appl_kpeYPMlCLVQCfwiuRuBdPOfYaLL';
const amazonApiKey = '';
const entitlementID = 'pro';
const entitlementIdAndroid = 'android';

//User database reference:

const String userFirstName = 'firstName';
const String userLastName = 'lastName';
const String userCountry = 'country';
const String userState = 'state';
const String userEmail = 'email';
const String userIpCountry = 'ipCountry';
const String userIpState = 'ipState';
const String userProfilePicUrl = 'profilePicUrl';
const String userImageUrlForChat = 'imageUrl';
const String userSymptomsList = 'symptoms';
const String userToDoList = 'toDo';
const String userInProgressList = 'inProgress';
const String userDoneList = 'done';
const String userDeletedTasksList = 'deletedTasks';
const String userSuggestedTasksList = 'suggestedTasks';
const String userSymptomAnalysis = 'symptomAnalysis';
const String userHomeAnalysis = 'homeAnalysis';
const String userProgressAnalysis = 'progressAnalysis';
const String userProgressList = 'progress';
const String userUserStoryList = 'userStory';
const String userIsDiagnosed = 'isDiagnosed';
const String userIsMedicalProfessional = 'isMedicalProfessional';
const String userIsAdmin = 'isAdmin';
const String userIsBanned = 'isBanned';
const String userIsSuperAdmin = 'isSuperAdmin';
const String userIsPro = 'isPro';
const String userOtherSymptomsList = 'otherSymptoms';
const String userUid = 'uid';
const String userHomeReportImageUrls = 'homeReportImageUrls';
const String userLabReportImageUrls = 'labReportImageUrls';
const String userSymptomReportImageUrls = 'symptomReportImageUrls';
const String userHomeReportPdfUrls = 'homeReportPdfUrls';
const String userLabReportPdfUrls = 'labReportPdfUrls';
const String userSymptomReportPdfUrls = 'symptomReportPdfUrls';
const String userGeneralReportPdfUrls = 'generalReportPdfUrls';
const String userMedicalHistoryList = 'medicalHistoryList';
const String userAiMediaUsageCount = 'aiMediaUsageCount';
const String userAiTextUsageCount = 'aiTextUsageCount';
const String userAiGeneralMediaUsageCount = 'aiGeneralMediaUsageCount';
const String userAiGeneralTextUsageCount = 'aiGeneralTextUsageCount';
const String userHealingJourneyMap = 'healingJourneyMap';
const String userDevice = 'device';
const String userWatchedVideoUrls = 'watchedVideoUrls';
const String userTimeStamp = 'timeStamp';
const String userShareJourneyPublicly = 'shareJourneyPublicly';
const String usersMessagingToken = 'messagingToken';

const homeImageSymptomChecker = 'assets/images/sick_lady_1280_640.jpg';
const homeImageSymptomCheckerSquare = 'assets/images/feeling_sick.jpeg';
const homeImageSymptomCheckerBlackWoman = 'assets/images/sick_black_woman.jpeg';
const homeImageInvestigateHome = 'assets/images/investigate_home.jpeg';
const homeImageInterpretLab = 'assets/images/lab_result.jpg';
const homeImageTrackProgress = 'assets/images/generate_report_lady.jpeg';
const homeImageVisualizeProgress = 'assets/images/visualize_healing.jpeg';
const homeImageAboutUs = 'assets/images/black_woman_doctor.jpeg';
const homeImageCommunity = 'assets/images/community.jpeg';
const homeImageToDo = 'assets/images/todo_list.jpeg';
const homeImageVideoResource = 'assets/images/viewing_phone.jpeg';

const String communityImageUrl =
    'https://firebasestorage.googleapis.com/v0/b/anecdotalhq.appspot.com/o/general%2Fapp_branding_images%2Fcommunity_avatar.jpeg?alt=media&token=233d4f87-3ac4-409b-a1b6-2df1fbd27487';

const String anecdotalLogoUrl =
    'https://firebasestorage.googleapis.com/v0/b/anecdotalhq.appspot.com/o/general%2Fapp_branding_images%2Fanecdotal_512.png?alt=media&token=b31737ac-d80d-40a6-9155-9358418a2b14';

const anecdotalMascotUrl =
    'https://firebasestorage.googleapis.com/v0/b/anecdotalhq.appspot.com/o/general%2Fapp_branding_images%2Fanecdotal_mascot.jpeg?alt=media&token=dda2fcaa-b806-4063-b3ba-8fb707fbc235';

const anecdotalMascot2Url =
    'https://firebasestorage.googleapis.com/v0/b/anecdotalhq.appspot.com/o/general%2Fapp_branding_images%2Fanecdotal_mascot2.jpeg?alt=media&token=f0719702-fa9b-4031-80d7-44e615448ed7';
const String communityRoomId = 'd6dFUDSPtW4bucnUIhkx';

const anecdotalMascotAssetUrl = 'assets/images/anecdotal_mascot.jpeg';

const String demoVideoAfroTech =
    'https://firebasestorage.googleapis.com/v0/b/anecdotalhq.appspot.com/o/general%2Fvideos%2FAnecdotal_AI_Demo_Afro_Tech.mp4?alt=media&token=8a0b9cc0-1af7-4bd8-a1e2-fe59ba36ae9f';

const String demoVideoGeneral =
    'https://firebasestorage.googleapis.com/v0/b/anecdotalhq.appspot.com/o/general%2Fvideos%2Fanecdotal_ai_demo%20.mp4?alt=media&token=8efda42e-ba51-4dab-af1c-977742086b84';
