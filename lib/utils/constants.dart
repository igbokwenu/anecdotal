//Gemini models documentation:https://ai.google.dev/models/gemini
const String geminiFlashModel = 'gemini-1.5-flash';
const String geminiProModel = 'gemini-1.5-pro';
const String gpt4OModel = "gpt-4o";
const String gpt4OMiniModel = "gpt-4o-mini";
const geminiApiKey = 'AIzaSyDbtCqs_Hl5deDeG5tLU_lE0XmTVoHUNkA';
const String chatGPTPremiumApiKey =
    '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';

const String myOpenAIKey =
    "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";

//Home Section
String symptomSectionHeader = "Analyze Your Symptoms";
String symptomSectionSummary =
    "Discover if your symptoms might be related to Mold illness. Simply share your story or select symptoms that applies to you from a list. Then, generate a report for insights. \n\nRemember, this is not medical advice, but a starting point for further discussion with a healthcare professional.";

String progressTrackerSectionHeader = "Track Your Progress";
String progressTrackerSectionSummary =
    "Monitor how your symptoms evolve over time. By tracking your daily or weekly progress, you can better understand the effectiveness of any treatments or lifestyle changes you've implemented. Consistent tracking can provide valuable insights into your health journey.";

String investigateSectionHeader = "Investigate Your Home";
String investigateSectionSummary =
    "Learn more about how your surroundings might be contributing to your condition. This section helps you identify potential environmental triggers like mold, dampness, or other harmful factors that could be affecting your health. Investigate and take steps to create a safer living space. You can either capture your surrounding using the camera or upload and analyze images for a specialized AI powered image analysis on potential mold growth that could make you sick.";

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
    "Understand your test results with confidence! This section offers clear explanations and expert insights to help you understand your lab results, empowering you to take informed action towards your recovery from mold illness and related conditions. \n\n**Please note that this is not a replacement or substitute for professional medical interpretation of the report. Always consult a qualified healthcare professional for personalized guidance and diagnosis.**";

class AppRoutes {
  static const String authWrapper = '/';
  static const String signUp = '/sign_up';
  static const String passwordRecovery = '/password_recovery';
  static const String home = '/home';
  static const String about = '/about';
  static const String privacy = '/privacy';
  static const String terms = '/terms';
  static const String account = '/account';
}

const String logoAssetImageUrlCircular = "assets/images/anecdotal_rounded.png";
const String logoAssetImageUrlCircularWithTag =
    "assets/images/anecdotal_rounded_tag.png";
const String logoAssetImageUrlNoTagLine = "assets/images/anecdotal_1000.png";
const String logoAssetImageUrlWithTagLine =
    "assets/images/anecdotal_logo_tag_2000.png";

//revenuecat keys
const googleApiKey = 'goog_vsEPEYPdkWRUGqBiNyaGMjSqHbt';
const appleApiKey = 'appl_kpeYPMlCLVQCfwiuRuBdPOfYaLL';
const amazonApiKey = '';
const entitlementID = 'pro';
