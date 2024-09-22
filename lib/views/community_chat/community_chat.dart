import 'package:anecdotal/providers/user_data_provider.dart';
import 'package:anecdotal/utils/constants/constants.dart';
import 'package:anecdotal/utils/reusable_function.dart';
import 'package:anecdotal/views/chat/utils.dart';
import 'package:anecdotal/views/edit_account_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommunityChatPage extends ConsumerStatefulWidget {
  const CommunityChatPage({
    super.key,
    required this.room,
  });

  final types.Room room;

  @override
  ConsumerState<CommunityChatPage> createState() => _CommunityChatPageState();
}

class _CommunityChatPageState extends ConsumerState<CommunityChatPage> {
  bool _isAttachmentUploading = false;

  @override
  void initState() {
    super.initState();
    _checkFirstSeen();
  }

  Future<void> _checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen_chat') ?? false);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userData = ref.watch(anecdotalUserDataProvider(uid)).value;

    if (!_seen) {
      await prefs.setBool('seen_chat', true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // ignore: prefer_const_constructors
        MyReusableFunctions.showCustomDialog(
          context: context,
          message:
              'Welcome to our community chat! The rules are simple: \n\nTreat others the way you want to be treated. \nSpeak to others the way you want to be spoken to. \nSupport others the way you want to be supported. \n\n❤️ ${userData!.lastName!.isEmpty ? '\n\nNote: Your display name is ${userData.firstName}. You can change it in your profile.' : ''}',
          actions: [
            if (userData.lastName!.isEmpty)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserProfileEditScreen(),
                    ),
                  );
                },
                child: const Text('Edit Profile'),
              ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Got it!'),
            ),
          ],
        );
      });
    }
  }

  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      _setAttachmentUploading(true);
      final name = result.files.single.name;
      final filePath = result.files.single.path!;
      final file = File(filePath);

      try {
        final reference = FirebaseStorage.instance.ref('chat_files/$name');
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();
        final message = types.PartialFile(
          mimeType: lookupMimeType(filePath),
          name: name,
          size: result.files.single.size,
          uri: uri,
        );

        FirebaseChatCore.instance.sendMessage(message, widget.room.id);
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final name = result.name;

      try {
        final reference = FirebaseStorage.instance.ref('chat_images/$name');
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialImage(
          height: image.height.toDouble(),
          name: name,
          size: size,
          uri: uri,
          width: image.width.toDouble(),
        );

        FirebaseChatCore.instance.sendMessage(
          message,
          widget.room.id,
        );
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final updatedMessage = message.copyWith(isLoading: true);
          FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            widget.room.id,
          );

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final updatedMessage = message.copyWith(isLoading: false);
          FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            widget.room.id,
          );
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final updatedMessage = message.copyWith(previewData: previewData);

    FirebaseChatCore.instance.updateMessage(updatedMessage, widget.room.id);
  }

  void _handleSendPressed(types.PartialText message) {
    FirebaseChatCore.instance.sendMessage(
      message,
      widget.room.id,
    );
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }

  Widget _avatarBuilder(types.User user) {
    final color = getUserAvatarNameColor(user);
    final hasImage = user.imageUrl != null && user.imageUrl!.isNotEmpty;
    final name = getUserName(user);

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? NetworkImage(user.imageUrl!) : null,
        radius: 20,
        child: !hasImage
            ? Text(
                name.isEmpty ? '' : name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userData = ref.watch(anecdotalUserDataProvider(uid)).value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.8),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: const Text('Community Chat'),
      ),
      body: StreamBuilder<types.Room>(
        initialData: widget.room,
        stream: FirebaseChatCore.instance.room(widget.room.id),
        builder: (context, snapshot) => StreamBuilder<List<types.Message>>(
          initialData: const [],
          stream: FirebaseChatCore.instance.messages(snapshot.data!),
          builder: (context, snapshot) => Chat(
            isAttachmentUploading: _isAttachmentUploading,
            messages: snapshot.data ?? [],
            onAttachmentPressed: _handleAtachmentPressed,
            onMessageTap: _handleMessageTap,
            onPreviewDataFetched: _handlePreviewDataFetched,
            onSendPressed: _handleSendPressed,
            user: types.User(
              id: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
              firstName: userData!.firstName,
              lastName: userData.lastName,
              // imageUrl: userData.profilePicUrl,
            ),
            showUserAvatars: true,
            showUserNames: true,
            // avatarBuilder: _avatarBuilder,
            theme: DefaultChatTheme(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              inputBackgroundColor: Colors.black.withOpacity(0.8),
            ),
          ),
        ),
      ),
    );
  }
}

Future<types.Room> joinCommunityChat() async {
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
      await FirebaseFirestore.instance.collection('rooms').doc(roomId).update({
        'userIds': FieldValue.arrayUnion([user.uid]),
      });
    }

    return room;
  } else {
    // Room doesn't exist, create it
    return await FirebaseChatCore.instance.createGroupRoom(
      name: 'Community Chat',
      users: [types.User(id: user.uid)],
      imageUrl: communityImageUrl,
    );
  }
}
