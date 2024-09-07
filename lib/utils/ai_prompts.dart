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
