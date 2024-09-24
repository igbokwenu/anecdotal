List<String> exposureHistory = [
  "Have you ever seen visible mold or mildew in your home, workplace, or school?",
  "Have you noticed a musty or mildewy smell in your environment?",
  "Have you experienced a known water leak or flood in your home, workplace, or school?",
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
  "Rule out Chronic Inflammatory Response Syndrome (CIRS)",
  "Get lab tests done for markers like C4a, MMP-9, and TGF-beta-1.",
  "Investigate home or surroundings for environmental toxins (e.g. Mold) that could be problematic",
];

List<String> cirsToDoTasks = [
  // Medical and Health-Related Tasks
  "Find a CIRS Specialist – Schedule a consultation with a doctor experienced in treating CIRS.",
  "Complete Lab Tests – Get lab tests done for markers like C4a, MMP-9, and TGF-beta-1.",
  "Start CIRS Treatment Protocol – Follow the prescribed treatment plan, such as the Shoemaker Protocol or similar.",
  "Take Medications/Supplements – Follow your doctor’s recommendations for binders (like cholestyramine), anti-inflammatories, or other prescribed supplements.",
  "Monitor Symptoms Daily – Track your symptoms and any changes to share with your healthcare provider.",
  "Retest Labs – Schedule follow-up lab tests to monitor progress and adjust treatment as needed.",

  // Environmental Remediation Tasks
  "Test Home for Mold – Arrange professional mold testing for your home (air and surface tests).",
  "Mold Remediation – Hire a professional to remediate mold, focusing on cleaning or removing contaminated materials.",
  "Purchase a HEPA Air Purifier – Use high-quality air purifiers in living spaces to reduce airborne toxins.",
  "Clean HVAC System – Regularly service and clean HVAC systems to prevent mold growth and contamination.",
  "Inspect Water Damage – Check home for any signs of water damage or leaks that could lead to mold.",

  // Lifestyle Changes
  "Follow a Low-Inflammatory Diet – Adopt an anti-inflammatory diet (e.g., avoiding sugar, processed foods, gluten, and dairy).",
  "Practice Stress Management – Engage in activities like meditation, yoga, or breathing exercises to reduce stress, which can worsen CIRS symptoms.",
  "Improve Sleep Hygiene – Establish a sleep routine to ensure quality rest, as CIRS can severely affect sleep patterns.",
  "Detox Support – Incorporate gentle detox practices such as saunas, lymphatic massage, or dry brushing, as recommended by your healthcare provider.",

  // Home and Personal Care Adjustments
  "Switch to Non-Toxic Products – Use chemical-free cleaning and personal care products to reduce toxin exposure.",
  "Avoid Water-Damaged Buildings (WDB) – Steer clear of environments that could trigger CIRS symptoms due to mold or water damage.",
  "Wash Clothes and Linens Regularly – Clean clothes and bedding often to avoid contamination with mold spores or toxins.",
  "Upgrade to Mold-Resistant Materials – Use mold-resistant paints, sealants, and construction materials during home repairs.",

  // Long-Term Planning
  "Schedule Regular Health Checkups – Plan for periodic check-ins with your doctor to adjust treatments and check on your progress.",
  "Educate Family and Friends – Share information about CIRS with your support system so they understand the importance of your treatment and environment.",
  "Create an Emergency Action Plan – Have a plan in place for flare-ups, including how to address immediate symptoms or evacuate to a safe environment."
];
