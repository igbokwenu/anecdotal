
import 'package:anecdotal/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final anecdotalUserDataProvider = StreamProvider.autoDispose.family<AnecdotalUserData?, String?>((ref, uid) {
  if (uid == null) return Stream.value(null);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .snapshots()
      .map((snapshot) => AnecdotalUserData.fromMap(snapshot.data()));
});