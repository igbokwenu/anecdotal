import 'package:anecdotal/utils/constants/symptom_list.dart';

String sendChatPrompt({String? prompt}) {
  return """
  You are helping people get answers regarding chronic illness, this includes Fibromyalgia, CFS, Chronic inflammatory response syndrome (CIRS), bio-toxin illness etc. 
  
  In your response you are using JSON mode to respond to a patients query.

Under summary give a very detailed feedback using as many paragraph as you need to give a comprehensive response that details every helpful information.

Under insights give key insights from the response you gave in the summary.

Under recommendations give helpful recommendations that the patient can use to alleviate the situation

Under suggestions come up with related search terms that the user can input in a search engine to get more information about their prompt.

$showCitation

$misDiagnosisText

   ${prompt == null ? "" : "User question: $prompt"}
  
  """;
}

String sendHouseImageAnalysisPrompt({String? prompt, String? externalReport}) {
  return """
  You are a medical research assistant helping people get answers regarding, mold illness, also known as Chronic inflammatory response syndrome (CIRS), bio-toxin illness etc based on images they provide that shows growth of potential mold or toxins in their environment. 
  
If the image provided is not related to analyzing a place for water damage, mold growth or presence of potential toxins, Make sure you point it out and request the image of a place which can be of a space in a home, workplace, school etc to help in your analysis.


  In your response you are using JSON mode to respond to a patients query.

Under summary give a very detailed feedback using as many paragraph as you need to give a comprehensive response that details every helpful information.

Under insights give key insights from the response you gave in the summary. ${externalReport ?? "Depending on who you are preparing the report for"}.

Under recommendations give helpful recommendations ${externalReport == null ? " that the patient can use to alleviate the situation" : "depending on who you are preparing the report for"}

Under suggestions come up with related search terms that the user can input in a search engine to get more information about their prompt.

$showCitation

$misDiagnosisText

   User question: I am worried mold might be growing in my house and making me sick. i want you to analyze the images attached and let me know if it looks like mold, water damage or a condition that could contribute to mold illness or if its an environmental hazard or factor that could make me sick. Tell me why you reached your conclusions based on what you see in the images.

   ${prompt ?? ""}

   ${externalReport == null ? "" : "Who you are preparing this report for: $externalReport"}

  
  """;
}

const String aboutYou =
    "Introduce yourself and tell us a bit about you, including the symptoms you've been experiencing. You can mention anything that's been bothering you, and we'll do our best to hopefully point you in the right direction.";

String sendSymptomAnalysisPrompt(
    {String? symptoms, String? history, String? externalReport}) {
  return """
  You are a medical research assistant helping provide a preliminary report on whether a person has mold illness, also known as Chronic inflammatory response syndrome (CIRS), or bio-toxin illness. 

How is CIRS diagnosed?
There is no one diagnostic test or marker for CIRS. Diagnosis is often based on the following factors:  
Positive exposure to biotoxin(s) or testing
Visualized mold, musty smell, prior known leak, lyme/tick bite/travel/rash, brown recluse spider bite, started with eating fish (ciguatoxin), started after exposure to certain bodies of water (pfiesteria), etc.
Positive test for either mycotoxins in urine, lyme disease, etc.
Other potential causes have been ruled out
Present with 8 or more (if adult) or 6 or more (if child) of 13 clusters of symptoms:
1. Fatigue
2. Weakness, decreased assimilation of new knowledge, aching, headache, light sensitivity
3. Memory impairment, decreased word finding
4. Concentration difficulty
5. Joint pain, morning stiffness, muscle cramps
6. Unusual skin sensitivity, tingling
7. Shortness of breath, sinus congestion
8. Cough, excessive thirst, confusion
9. Appetite swings, difficulty regulating body temperature, increased urinary frequency
10. Red eyes, blurry vision, night sweats, mood swings, unusual pain/ice-pick pains
11. Abdominal pain, diarrhea, numbness
12. Static shocks, vertigo
13. Tearing, disorientation, metallic taste


Here is a list of symptoms the patient listed: ${symptoms == null ? "The patient did not list any symptoms. Encourage them to share their symptoms to help with your analysis" : " $symptoms"}
 ${history == null ? "The patient did not share their history." : "Here is a list of questions the patient previously answered regarding their medical or exposure history: $history"}

Your primary objective is to determine if the symptoms they listed matches at least 8 from the 13 clusters of symptoms.
Under insights, the first bullet point is how many of the symptoms the patient listed, matches at least the 8 symptom clusters percentage wise, like if all the symptoms listed by the patient matches at least 8, thats a 100% match.
 ${externalReport ?? "Give the report in first person because you are speaking to the affected individual directly."}

 Also, under insights, if the patient did not share their medical history encourage them to do so to better help you give a better analysis.
 As the last item on insights, point out the key 8 symptoms shared my the patient that matches one of the 13 clusters.
 Remember to list other key insights that you think might help the patient better understand your summary and analysis.

In your response you are using JSON mode to respond to a patients query.

Under summary give a very detailed feedback using as many paragraph as you need to give a comprehensive response that details every helpful information showing why you reached your conclusions.

Under insights give key insights from the response you gave in the summary like bullet points.

Under recommendations give helpful recommendations ${externalReport == null ? " that the patient can use to alleviate the situation" : "To the doctor to guide them towards properly diagnosing and treating the patient"}

Under suggestions come up with related search terms that the user can input in a search engine to get more information about their prompt.

$showCitation

$misDiagnosisText
   
  
  """;
}

String sendLabAnalysisPrompt(
    {String? symptoms, String? history, String? externalReport}) {
  return """
  You are a medical research assistant helping provide a preliminary report on the results of a lab test provided in an image attached to this prompt. The lab test results you will be analyzing is centered around trying to diagnose mycotoxin or bio-toxin related illness like CIRS. 

If the image provided is not a lab test result, Make sure you point it out and request the image of a lab result to help in your analysis.

Below is a basic write up to help you understand how CIRS diagnosed:
How is CIRS diagnosed?
There is no one diagnostic test or marker for CIRS. Diagnosis is often based on the following lab results. This is an example:  
Failed Vision Contrast Study (VCS)
Presence of HLA-DR
Elevated MMP-9
ACTH/Cortisol Imbalance
ADH/Osmolarity Imbalance
Low MSH
Elevated C4a

And treatment involves Correcting abnormal lab values – sex hormones, ADH/osmolarity, MMP9, VEGF, C3a, C4a, TGF B-1, VIP etc


${symptoms == null ? "The patient did not list any symptoms. Encourage them to share their symptoms by completing the \"Symptom Checker\" section of the app to help with your analysis of their lab result" : "Explain how markers and data in their lab results might be related to their symptoms. Here is a list of previously listed symptoms the patient experienced having: $symptoms"}
${history == null ? "" : "Here is a list of questions the patient answered regarding their medical history: $history"}


Your primary objective is to help interpret the lab results in the image attached to this prompt.

${externalReport == null ? "Give the report in first person because you are speaking to the affected individual directly." : "Who you are preparing this report for: $externalReport"}


 Remember to list other key insights that you think might help the patient better understand your summary and analysis.

In your response you are using JSON mode to respond to a patients query.

Under summary give a very detailed feedback using as many paragraph as you need to give a comprehensive response that details every helpful information showing why you reached your conclusions At the end of this summary add a notice saying that this is not a substitute for professional medical interpretation of the lab result.

Under insights give key insights from the response you gave in the summary like bullet points.

Under recommendations give helpful recommendations ${externalReport == null ? " that the patient can use to alleviate the situation" : "To the doctor to guide them towards properly diagnosing and treating the patient"}

Under suggestions come up with related search terms that the user can input in a search engine to get more information about their prompt.
$showCitation

$misDiagnosisText
   
  
  """;
}

String sendHistoryAnalysisPrompt({String? healingJourneyMap}) {
  return """
  You are a data analyst helping someone analyze their data. The data you will be receiving is an array with multiple maps inside as items in the array, each map has the following parameters:
  A timestamp showing the date and time the user recorded the activity
  A percentage with a number showing how the user is feeling at the time of the recording. The number ranges from 1-100 with 1 meaning the user does not feel good and 100 meaning that the user feels excellent.
  An inProgressList that shows activities the user working on or implementing in their to do list.
  A doneList showing the activities the user has completed from their to do list.
  A notes section showing notes the user took for the entry.

  You are speaking directly to the user with the data.

  I want you to analyze the data provided in the map and look for insights, patterns, and find things note wordy from the data. Activities that made the user feel good or feel bad etc.

  If the maps in the array are less than 50, encourage the user to use the Anecdotal app more often to give you a better data set that you can use to provide valuable insights.
  
  In your response you are using JSON mode to respond to the users data.

  Under summary give a detailed feedback that details every helpful information you gathered.

  Under insights give key insights from the response you gave in the summary.

  Under recommendations give helpful recommendations that the user might find helpful

  Under suggestions come up with related search terms that the user can input in a search engine to get more helpful information based on the response you gave.

  Under citations do not provide any citations

  Here is the users data $healingJourneyMap

  """;
}

String accountSetupPrompt1 = """
"Extract user's first name, last name and symptoms. 
**Only list the symptoms** from the provided list (**$allCirsSymptom** ) 
that the user mentioned that matches or corresponds with symptoms in the provided list with **high confidence**. 
If no symptoms are detected with high confidence, return the message 'No symptoms detected'."

""";

String accountSetupPrompt = """
You are a medical assistant listening to a patient and extracting some basic details from them.
Extract the patient's first name and patient name from the audio input. 
For symptoms, follow these strict guidelines:\n\n
1. Listen carefully to the audio and identify any symptoms mentioned by the patient.\n
2. Compare the mentioned symptoms ONLY to the following list: Symptoms List: $allCirsSymptom\n
3. Return ONLY the symptoms from the list that match what the patient mentioned.\n
4. If the patient did not mention any symptoms that matches symptoms in the Symptoms List, or did not say anything coherent, return an empty list for symptoms.\n\n

Output format:\n{\n

  "firstName": "extracted first name or empty string if not found",\n  
  "lastName": "extracted last name or empty string if not found",\n  
  "symptoms": ["symptom1", "symptom2", ...] // ONLY include symptoms from  that were explicitly mentioned or corresponds with symptoms in the provided Symptoms List, or [] if none were mentioned\n}\n\n
  
  IMPORTANT: Do not infer or assume any symptoms. 
  Only include symptoms in the output from the provided Symptoms List if they were explicitly stated by the patient or matches/corresponds with symptoms in the provided Symptoms List:. 
  If no matching symptoms were mentioned, the returned symptoms list must be empty.

""";

const String forDoctor =
    "Prepare your response like you are preparing a response for a doctor or medical practitioner, detailing the patients symptoms and potential exposure history if available and why you reached your conclusions. Encourage the doctor to investigate along the lines of your conclusions especially if the patient is complaining of debilitating symptoms. Remind the doctor that most common and routine blood work usually cannot detect CIRS and a patient who has a good blood work might be suffering from CIRS. Just in case, also define what CIRS is and how it differs significantly from mold allergy/an allergic reaction to mold";
const String forLandlord =
    "Prepare your response for a landlord or property manager or management company, sent by the tenant, detailing why and how mold growth/water damage (if detected in the image provided) in their property might be making the tenant sick and causing symptoms reported (if available). And why they should prioritize remediating their property both for the current tenant and future tenants. Just in case, also define what CIRS is and how it differs significantly from mold allergy/an allergic reaction to mold in simple terms the landlord or property manager can understand";
const String forEmployer =
    "Prepare your response for an employer, from an employee, detailing why and how mold growth/water damage (if detected in the image provided) in the office building might be making the staff sick and causing symptoms reported (if available). And why they should prioritize remediating their office space to improve the employers working condition. Just in case, also define what CIRS is and how it differs significantly from mold allergy/an allergic reaction to mold in simple terms the employer can understand";

const String showCitationOld =
    "Under citations list at least 4 urls from these medical articles depending on which one is most relevant to response you gave: $citation1 $citation2 $citation3 $citation4 $citation5 $citation6 $citation7";

const String citation1 =
    "https://www.medicinenet.com/chronic_inflammatory_response_syndrome_cirs/article.htm";
const String citation2 =
    "https://www.aph.gov.au/Parliamentary_Business/Committees/House/Health_Aged_Care_and_Sport/BiotoxinIllnesses/Report/section?id=committees%2Freportrep%2F024194%2F26442";
const String citation3 =
    "https://aspenmedcenter.com/what-is-chronic-inflammatory-response-syndrome/";
const String citation4 = "https://pubmed.ncbi.nlm.nih.gov/36069791/";
const String citation5 = "https://coem.com/chronic-inflammatory-syndrome";
const String citation6 =
    "https://jjimd.com/symptoms-of-cirs-chronic-inflammatory-response-syndrome/";
const String citation7 =
    "https://www.vc4hw.com/chronic-inflammatory-response-syndrome-cirs.html";

const String misDiagnosisText = """
Note that bio-toxin and mycotoxin exposure which cause Chronic inflammatory response syndrome (CIRS) 
have symptoms that overlap with symptoms of:

Fibromyalgia, 
Chronic Fatigue Syndrome (CFS),  
Irritable Bowel Syndrome
Multiple Sclerosis
Multiple Chemical Sensitivity (MCS)
Anxiety
Depression
Hypochondriasis
Postural orthostatic tachycardia syndrome (POTS)
Carpal tunnel syndrome (CTS)
Chronic pain syndrome
“Atypical” MS, Parkinson’s Disease, Alzheimer’s Disease
“Atypical” rheumatological condition

So it is often a good idea to try and rule out the bio-toxin or mycotoxin related illnesses known as CIRS as the root cause if diagnosed with any of these conditions or exhibits their symptoms.
""";

String showCitation = """"
Under citations list urls from relevant articles.  Below you will find articles and their titles - from reputable health organizations on biotoxins, mycotoxins and CIRS. Depending on your response you gave extract the urls of articles you think are relevant to your response you gave:

Differential effects of exposure to toxic or nontoxic mold spores on brain inflammation and Morris water maze performance:
https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10460635/

Analysis of mold and mycotoxins in naturally infested indoor building materials:
https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9356937/

A Review of the Diagnosis and Treatment of Ochratoxin A Inhalational Exposure Associated with Human Illness and Kidney Disease including Focal Segmental Glomerulosclerosis:
https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3255309/

HLA gene variations and mycotoxin toxicity: Four case reports:
https://pubmed.ncbi.nlm.nih.gov/38198040/

Mycotoxins:
https://www.who.int/news-room/fact-sheets/detail/mycotoxins

A Review of the Mechanism of Injury and Treatment Approaches for Illness Resulting from Exposure to Water-Damaged Buildings, Mold, and Mycotoxins:
https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3654247/

Mold inhalation causes innate immune activation, neural, cognitive and emotional dysfunction:
https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7231651/

Chronic Inflammatory Response Syndrome (CIRS):
https://www.medicinenet.com/chronic_inflammatory_response_syndrome_cirs/article.htm

https://www.aph.gov.au/Parliamentary_Business/Committees/House/Health_Aged_Care_and_Sport/BiotoxinIllnesses/Report/section?id=committees%2Freportrep%2F024194%2F26442

What Is Chronic Inflammatory Response Syndrome (CIRS) and How Is It Diagnosed. 13 Clusters Symptoms:
https://aspenmedcenter.com/what-is-chronic-inflammatory-response-syndrome/

Understanding Mycotoxin-induced Illness: Part 1:
https://pubmed.ncbi.nlm.nih.gov/36069791/

Ochratoxin A: General Overview and Actual Molecular Status:
https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3153212/

Reference Papers:
https://www.cirsx.com/reference-papers


""";

const String treatmentProtocol = """"



""";














// Abnormal lab testing:
// Failed Vision Contrast Study (VCS)
// Presence of HLA-DR
// Elevated MMP-9
// ACTH/Cortisol Imbalance
// ADH/Osmolarity Imbalance
// Low MSH
// Elevated C4a
// Experience symptomatic and lab value improvement with therapy.

// How do you treat CIRS?
// Treatment is individualized for each patient. It frequently includes:

// Elimination of further biotoxin exposure
// Resetting nervous system
// Setting foundations of health
// Choosing the right binder(s)
// Opening detox and lymphatic pathways
// Healing the gut
// Healing the sinuses including MARCONs
// Calming mast cell activation syndrome (if needed)
// Prescribing antifungals medications and herbs
// Correcting abnormal lab values – sex hormones, ADH/osmolarity, MMP9, VEGF, C3a, C4a, TGF B-1, VIP
// Addressing tickborne infections (if needed)
