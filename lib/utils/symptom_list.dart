List<Map<String, dynamic>> cirsSymptomCategories = [
  {
    'category': 'General/Constitutional Symptoms',
    'symptoms': [
      "Persistent fatigue and weakness",
      "Body aches, muscle cramps, and unusual pains",
      "Morning stiffness and joint pain, with or without swelling",
      "Headaches, including migraines and ice-pick or sharp, lightning-bolt pains",
      "Difficulty regulating body temperature, including frequent sweats (especially night sweats)",
      "Weight gain or loss",
      "Static shocks",
    ],
  },
  {
    'category': 'Neurological and Cognitive Symptoms',
    'symptoms': [
      "Memory loss and/or difficulty concentrating",
      "Difficulty finding words or decreased ability to learn new information",
      "Confusion and disorientation",
      "Cognitive impairment and 'brain fog'",
      "Unusual sensations such as numbness, tingling, or a 'buzzing' or tremor sensation",
      "Electric-like painful shocks and feelings of crawling or clawing under the skin",
      "Vertigo or dizziness",
      "Seizure-like episodes",
      "Tremors, tics, or spasms",
    ],
  },
  {
    'category': 'Psychiatric Symptoms',
    'symptoms': [
      "Mood swings, irritability, and unprovoked anger",
      "Anxiety and depression",
      "Post-Traumatic Stress Disorder (PTSD) symptoms",
      "Insomnia and difficulty sleeping",
    ],
  },
  {
    'category': 'Eye and Vision Symptoms',
    'symptoms': [
      "Sensitivity to light (photophobia)",
      "Red or bloodshot eyes",
      "Blurred vision",
      "Tearing or watery eyes",
    ],
  },
  {
    'category': 'Respiratory Symptoms',
    'symptoms': [
      "Chronic sinus congestion or sinusitis",
      "Shortness of breath and air hunger",
      "Cough and chest pain",
      "Asthma-like respiratory symptoms or bronchospasms",
      "Pulmonary hypertension",
    ],
  },
  {
    'category': 'Cardiovascular Symptoms',
    'symptoms': [
      "Palpitations or rapid heartbeat",
      "Low blood pressure (hypotension)",
    ],
  },
  {
    'category': 'Gastrointestinal Symptoms',
    'symptoms': [
      "Abdominal pain, bloating, and nausea",
      "Diarrhea or constipation",
      "Leaky gut syndrome",
      "Gallbladder dysfunction, including gallbladder removal",
      "Appetite changes or swings",
    ],
  },
  {
    'category': 'Skin Symptoms',
    'symptoms': [
      "Skin sensitivity to light touch or rashes",
      "Stretch marks or pruritis (itchiness)",
      "Unusual sensations under the skin",
    ],
  },
  {
    'category': 'Genitourinary Symptoms',
    'symptoms': [
      "Frequent urination (polyuria) and increased nighttime urination (nocturia)",
      "Excessive thirst despite drinking fluids",
      "Sexual dysfunction, including impotence or infertility in some cases",
    ],
  },
  {
    'category': 'Other Symptoms',
    'symptoms': [
      "Metallic taste in the mouth",
      "Increased sensitivity to chemicals (multiple chemical sensitivity)",
      "Mast cell activation syndrome",
      "Prone to frequent infections",
    ],
  },
];

List<String> cirsSymptoms = [
  // General/Constitutional Symptoms
  "Persistent fatigue and weakness",
  "Body aches, muscle cramps, and unusual pains",
  "Morning stiffness and joint pain, with or without swelling",
  "Headaches, including migraines and ice-pick or sharp, lightning-bolt pains",
  "Difficulty regulating body temperature, including frequent sweats (especially night sweats)",
  "Weight gain or loss",
  "Static shocks",

  // Neurological and Cognitive Symptoms
  "Memory loss and/or difficulty concentrating",
  "Difficulty finding words or decreased ability to learn new information",
  "Confusion and disorientation",
  "Cognitive impairment and 'brain fog'",
  "Unusual sensations such as numbness, tingling, or a 'buzzing' or tremor sensation",
  "Electric-like painful shocks and feelings of crawling or clawing under the skin",
  "Vertigo or dizziness",
  "Seizure-like episodes",
  "Tremors, tics, or spasms",

  // Psychiatric Symptoms
  "Mood swings, irritability, and unprovoked anger",
  "Anxiety and depression",
  "Post-Traumatic Stress Disorder (PTSD) symptoms",
  "Insomnia and difficulty sleeping",

  // Eye and Vision Symptoms
  "Sensitivity to light (photophobia)",
  "Red or bloodshot eyes",
  "Blurred vision",
  "Tearing or watery eyes",

  // Respiratory Symptoms
  "Chronic sinus congestion or sinusitis",
  "Shortness of breath and air hunger",
  "Cough and chest pain",
  "Asthma-like respiratory symptoms or bronchospasms",
  "Pulmonary hypertension",

  // Cardiovascular Symptoms
  "Palpitations or rapid heartbeat",
  "Low blood pressure (hypotension)",

  // Gastrointestinal Symptoms
  "Abdominal pain, bloating, and nausea",
  "Diarrhea or constipation",
  "Leaky gut syndrome",
  "Gallbladder dysfunction, including gallbladder removal",
  "Appetite changes or swings",

  // Skin Symptoms
  "Skin sensitivity to light touch or rashes",
  "Stretch marks or pruritis (itchiness)",
  "Unusual sensations under the skin",

  // Genitourinary Symptoms
  "Frequent urination (polyuria) and increased nighttime urination (nocturia)",
  "Excessive thirst despite drinking fluids",
  "Sexual dysfunction, including impotence or infertility in some cases",

  // Other Symptoms
  "Metallic taste in the mouth",
  "Increased sensitivity to chemicals (multiple chemical sensitivity)",
  "Mast cell activation syndrome",
  "Prone to frequent infections"
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
