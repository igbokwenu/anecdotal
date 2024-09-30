List<String> exposureHistory = [
  "Have you ever seen visible mold or mildew in your home, workplace, or school?",
  "Have you ever noticed a musty or mildewy smell in your environment?",
  "Have you ever experienced a known water leak or flood in your home, workplace, or school?",
  "Have you been bitten by a tick or exposed to Lyme disease?",
  "Have you traveled to an area known for Lyme disease or tick-borne illnesses?",
  "Have you experienced a rash or lesion after a tick bite?",
  "Have you been bitten by a brown recluse spider?",
  "Did your symptoms start after eating fish, especially tropical fish?",
  "Did your symptoms start after exposure to certain bodies of water, such as a lake or river?",
];

List<String> allCirsSymptom = [
  ...generalSymptoms,
  ...neurologicalSymptoms,
  ...psychiatricSymptoms,
  ...eyeSymptoms,
  ...respiratorySymptoms,
  ...cardiovascularSymptoms,
  ...gastrointestinalSymptoms,
  ...skinSymptoms,
  ...genitourinarySymptoms,
  ...otherSymptoms,
];

//Broken down:

// General/Constitutional Symptoms
List<String> generalSymptoms = [
  "Persistent fatigue and weakness",
  "Body aches, muscle cramps, and unusual pains",
  "Morning stiffness and joint pain, with or without swelling",
  "Headaches, including migraines and ice-pick or sharp, lightning-bolt pains",
  "Difficulty regulating body temperature, including frequent sweats (especially night sweats)",
  "Weight gain or loss",
  "Static shocks",
];

// Neurological and Cognitive Symptoms
List<String> neurologicalSymptoms = [
  "Memory loss and/or difficulty concentrating",
  "Difficulty finding words or decreased ability to learn new information",
  "Confusion and disorientation",
  "Cognitive impairment and 'brain fog'",
  "Unusual sensations such as numbness, tingling, or a 'buzzing' or tremor sensation",
  "Electric-like painful shocks and feelings of crawling or clawing under the skin",
  "Vertigo or dizziness",
  "Seizure-like episodes",
  "Tremors, tics, or spasms",
];

// Psychiatric Symptoms
List<String> psychiatricSymptoms = [
  "Mood swings, irritability, and unprovoked anger",
  "Anxiety and depression",
  "Post-Traumatic Stress Disorder (PTSD) symptoms",
  "Insomnia and difficulty sleeping",
];

// Eye and Vision Symptoms
List<String> eyeSymptoms = [
  "Sensitivity to light (photophobia)",
  "Red or bloodshot eyes",
  "Blurred vision",
  "Tearing or watery eyes",
];

// Respiratory Symptoms
List<String> respiratorySymptoms = [
  "Chronic sinus congestion or sinusitis",
  "Shortness of breath and air hunger",
  "Cough and chest pain",
  "Asthma-like respiratory symptoms or bronchospasms",
  "Pulmonary hypertension",
];

// Cardiovascular Symptoms
List<String> cardiovascularSymptoms = [
  "Palpitations or rapid heartbeat",
  "Low blood pressure (hypotension)",
];

// Gastrointestinal Symptoms
List<String> gastrointestinalSymptoms = [
  "Abdominal pain, bloating, and nausea",
  "Diarrhea or constipation",
  "Leaky gut syndrome",
  "Gallbladder dysfunction, including gallbladder removal",
  "Appetite changes or swings",
];

// Skin Symptoms
List<String> skinSymptoms = [
  "Skin sensitivity to light touch or rashes",
  "Stretch marks or pruritis (itchiness)",
  "Unusual sensations under the skin",
];

// Genitourinary Symptoms
List<String> genitourinarySymptoms = [
  "Frequent urination (polyuria) and increased nighttime urination (nocturia)",
  "Excessive thirst despite drinking fluids",
  "Sexual dysfunction, including impotence or infertility in some cases",
];

// Other Symptoms
List<String> otherSymptoms = [
  "Metallic taste in the mouth",
  "Increased sensitivity to chemicals (multiple chemical sensitivity)",
  "Mast cell activation syndrome",
  "Prone to frequent infections",
];

List<String> additionalCirsSymptoms = [
  "Tinnitus (ringing in the ears)",
  "White noise (in ears or head)",
  "Internal vibrations",
  "Occipital neuralgia (nerve pain in the back of the head)",
  "Balance issues",
  "White and black bursts of light in vision",
  "Pressure in the head",
  "Icepick sensations in the brain",
  "Feeling numb to emotions",
  "Lump in throat sensation",
  "Feeling like being in a dream or sleep-deprived despite rest",
  "Swollen tonsils",
  "Feeling like there's something stuck in the throat",
  "Right neck pain and numbness",
  "Neck and throat feeling numb and puffy but visually normal",
  "White coating on the tongue",
  "Heat sensitivity, always wanting to be in a cold environment",
  "Loopy or high feeling",
  "Really bad histamine reactions after eating",
  "Eyes extremely dry",
  "Gut issues and food intolerance",
  "Weird rushes throughout the body (tingly or hot)",
  "Emotionally disconnected or dissociation",
  "Zero energy or extreme fatigue",
  "Lack of physical sensation",
  "Feeling heartbeat in the stomach",
  "Heart beating aggressively when stressed",
  "Neck, sternum, and rib pain",
  "Leg twitching",
  "Weakness in the left arm"
];

List<String> toDoSuggestions = [
  "Rule out Mycotoxins if experiencing chronic symptoms - Using Anecdotal AI's Symptom Checker",
  "Investigate home or surroundings for environmental toxins - using Anecdotal AI's Investigate feature",
  "Connect with others in the Anecdotal AI community",
  "Learn more about Mycotoxins and how they can negatively affect your health in the Video Resources section of the app",
  "Adopt a low-inflammatory diet.",
  "Practice stress management (e.g., meditation, sleep cycle stability etc).",
  "Relocate from space that has environmental toxins.",
  "Remediate space that has environmental toxins.",
];

List<String> cirsToDoTasks = [
  // Medical and Health-Related Tasks
  "Find a CIRS specialist for consultation.",
  // "Start prescribed CIRS treatment protocol.",
  // "Take medications/supplements as prescribed.",
  "Monitor symptoms daily.",
  "Monitor and adjust current treatments/activities as needed.",

  // Environmental Remediation Tasks
  "Test home for toxins (air/surface).",
  "Hire professional home remediation specialist.",
  "Use HEPA air purifiers in living spaces.",
  "Clean HVAC system regularly.",
  "Inspect for water damage or leaks.",

  // Lifestyle Changes
  "Improve sleep hygiene with a routine.",
  "Incorporate detox practices (e.g., sauna).",

  // Home and Personal Care Adjustments
  "Switch to non-toxic cleaning products.",
  "Relocate from water-damaged buildings (WDB).",
  "Wash clothes and linens regularly.",
  "Use mold-resistant materials for repairs.",

  // Long-Term Planning
  "Schedule regular health checkups.",
  "Educate family/friends about CIRS.",
  "Create an emergency action plan for flare-ups.",
  "Complete lab tests (C4a, MMP-9, TGF-beta-1).",
];
