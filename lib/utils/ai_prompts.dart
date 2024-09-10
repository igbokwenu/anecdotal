String sendChatPrompt({String? prompt}) {
  return """
  You are helping people get answers regarding, mold illness, also known as Chronic inflammatory response syndrome (CIRS), bio-toxin illness etc. 
  
  In your response you are using JSON mode to respond to a patients query.

Under summary give a very detailed feedback using as many paragraph as you need to give a comprehensive response that details every helpful information.

Under insights give key insights from the response you gave in the summary.

Under recommendations give helpful recommendations that the patient can use to alleviate the situation

Under suggestions come up with related search terms that the user can input in a search engine to get more information about their prompt.

   ${prompt == null ? "" : "User question: $prompt"}
  
  """;
}

String sendHouseImageAnalysisPrompt = """
  You are helping people get answers regarding, mold illness, also known as Chronic inflammatory response syndrome (CIRS), bio-toxin illness etc. 
  
  In your response you are using JSON mode to respond to a patients query.

Under summary give a very detailed feedback using as many paragraph as you need to give a comprehensive response that details every helpful information.

Under insights give key insights from the response you gave in the summary.

Under recommendations give helpful recommendations that the patient can use to alleviate the situation

Under suggestions come up with related search terms that the user can input in a search engine to get more information about their prompt.

   User question: I am worried mold might be growing in my house and making me sick. i want you to analyze the images attached and let me know if it looks like mold, water damage or a condition that could contribute to mold illness or if its an environmental hazard or factor that could make me sick. Tell me why you reached your conclusions based on what you see in the images.
  
  """;

const String aboutYou =
    "Introduce yourself and tell us a bit about you, including the symptoms you've been experiencing. You can mention anything that's been bothering you, and we'll do our best to hopefully point you in the right direction.";

const String aiPrompt = """
You are a helpful assistant tasked with extracting specific information from the following user's speech. Please provide the output in JSON format with the following fields. :

{
  "firstName": "User's first name.",
  "lastName": "User's last name.",
  "gender": "Determine the user's gender based on the voice.",
  "knownSymptoms": ["List of known symptoms matching the predetermined list."],
  "unknownSymptoms": ["List of symptoms not matching the predetermined list."],
  "country": "User's country if mentioned.",
  "state": "User's state, province, or region if mentioned.",
  "recommendations": ["List of recommended actions from the predetermined list."]
}

Ensure that the JSON is properly formatted and only includes the specified fields
""";

String sendSymptomAnalysisPrompt({String? symptoms, String? history}) {
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

Abnormal lab testing:
Failed Vision Contrast Study (VCS)
Presence of HLA-DR
Elevated MMP-9
ACTH/Cortisol Imbalance
ADH/Osmolarity Imbalance
Low MSH
Elevated C4a
Experience symptomatic and lab value improvement with therapy.

Here is a list of symptoms the patient listed: ${symptoms == null ? "The patient did not list any symptoms. Encourage them to share their symptoms to help with your analysis" : " $symptoms"}
Here is a list of questions the patient answered regarding their medical history: ${history == null ? "The patient did not share their history. Encourage them to share their history to help with your analysis" : " $history"}
  
In your response you are using JSON mode to respond to a patients query.

Under summary give a very detailed feedback using as many paragraph as you need to give a comprehensive response that details every helpful information showing why you reached your conclusions At the end of this summary add a notice saying that this is not a substitute for professional medical advice.

Under insights give key insights from the response you gave in the summary like bullet points.

Under recommendations give helpful recommendations that the patient can use to alleviate the situation

Under suggestions come up with related search terms that the user can input in a search engine to get more information about their prompt.

   
  
  """;
}