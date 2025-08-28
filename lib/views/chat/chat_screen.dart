// views/chat/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appchatfl/controllers/chat_controller.dart';
import 'package:appchatfl/controllers/auth_controller.dart';
import 'package:appchatfl/widgets/chat_bubble.dart';
import 'package:appchatfl/widgets/message_input.dart';
import 'package:appchatfl/models/user_model.dart';

class ChatScreen extends StatefulWidget {
  final UserModel user;

  const ChatScreen({
    super.key,
    required this.user,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController _chatController = Get.find<ChatController>();
  final AuthController _authController = Get.find<AuthController>();
  final ScrollController _scrollController = ScrollController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _chatController.loadMessages(widget.user.uid);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = _auth.currentUser?.uid ?? _authController.user?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.transparent,
              backgroundImage: widget.user.avatarUrl != null
                  ? NetworkImage(widget.user.avatarUrl!)
                  : null,
              child: widget.user.avatarUrl == null
                  ? Text(
                widget.user.fullName.isNotEmpty
                    ? widget.user.fullName[0].toUpperCase()
                    : 'U',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
                  : null,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.fullName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Obx(() => Text(
                  widget.user.isOnline ? 'Online' : 'Offline',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                )),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Call functionality
              Get.snackbar('Coming Soon', 'Voice call feature will be available soon');
            },
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {
              // Video call functionality
              Get.snackbar('Coming Soon', 'Video call feature will be available soon');
            },
            icon: const Icon(Icons.videocam),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (_chatController.isLoading && _chatController.messages.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                controller: _scrollController,
                reverse: true,
                padding: const EdgeInsets.all(16),
                itemCount: _chatController.messages.length,
                itemBuilder: (context, index) {
                  final message = _chatController.messages[index];
                  final isMe = message.senderId == currentUserId;

                  return ChatBubble(
                    message: message,
                    isMe: isMe,
                  );
                },
              );
            }),
          ),
          MessageInput(
            onSendMessage: (message) {
              _chatController.sendMessage(message);
              _scrollToBottom();
            },
          ),
        ],
      ),
    );
  }
}