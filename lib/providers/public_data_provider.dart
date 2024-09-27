import 'package:anecdotal/models/public_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final publicDataProvider = StreamProvider.autoDispose<PublicData>((ref) {
  return FirebaseFirestore.instance
      .collection('general')
      .doc('public')
      .snapshots()
      .map((snapshot) => PublicData.fromMap(snapshot.data()));
});
