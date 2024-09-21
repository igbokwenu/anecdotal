import 'package:anecdotal/utils/constants/constants.dart';
import 'package:anecdotal/views/chat/chat.dart';
import 'package:anecdotal/views/community_chat/community_chat.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatUtils {
  static Future<types.Room> joinCommunityChat() async {
    final user = FirebaseChatCore.instance.firebaseUser;
    if (user == null) throw Exception('User is not authenticated');

    // Check if community chat room exists
    final querySnapshot = await FirebaseFirestore.instance
        .collection('rooms')
        .where('name', isEqualTo: 'Community Chat')
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Room exists, join it
      final roomId = querySnapshot.docs.first.id;
      final room = await FirebaseChatCore.instance.room(roomId).first;

      // Check if user is already a participant
      if (!room.users.any((u) => u.id == user.uid)) {
        // Add user to participants
        await FirebaseFirestore.instance
            .collection('rooms')
            .doc(roomId)
            .update({
          'userIds': FieldValue.arrayUnion([user.uid]),
        });
      }

      return room;
    } else {
      // Room doesn't exist, create it
      return await FirebaseChatCore.instance.createGroupRoom(
        name: 'Community Chat',
        users: [types.User(id: user.uid)],
        imageUrl: communityImageUrl, // Optional
      );
    }
  }

  static void navigateToCommunityChat(BuildContext context) async {
    try {
      final communityRoom = await joinCommunityChat();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CommunityChatPage(room: communityRoom),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to join community chat: $e')),
      );
    }
  }
}
