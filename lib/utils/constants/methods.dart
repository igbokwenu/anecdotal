

List<String> filterSymptoms(
    List<String> snapshot, List<String> modifiedSymptoms) {
  // Check if snapshot contains any string not in modifiedProfessions
  bool hasUnmodifiedSymptoms =
      snapshot.any((symptom) => !modifiedSymptoms.contains(symptom));

  if (hasUnmodifiedSymptoms) {
    // Remove items from snapshot that are not in modifiedProfessions
    return snapshot
        .where((symptom) => modifiedSymptoms.contains(symptom))
        .toList();
  } else {
    // Return the original snapshot list as it only contains professions in modifiedProfessions
    return snapshot;
  }
}