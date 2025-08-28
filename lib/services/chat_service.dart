// services/chat_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appchatfl/models/message_model.dart';
import 'package:appchatfl/models/user_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get all users except current user
  Stream<List<UserModel>> getUsers() {
    return _firestore
        .collection('users')
        .where('uid', isNotEqualTo: _auth.currentUser!.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Get messages between current user and another user
  Stream<List<MessageModel>> getMessages(String userId) {
    // Get current user ID
    final currentUserId = _auth.currentUser!.uid;
    
    // Determine chat room ID (sorted to ensure consistency)
    final List<String> ids = [currentUserId, userId];
    ids.sort();
    final chatRoomId = ids.join('_');

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Send a message
  Future<void> sendMessage(String receiverId, String content) async {
    try {
      // Get current user info
      final currentUserId = _auth.currentUser!.uid;
      final currentUserEmail = _auth.currentUser!.email!;
      
      // Determine chat room ID (sorted to ensure consistency)
      final List<String> ids = [currentUserId, receiverId];
      ids.sort();
      final chatRoomId = ids.join('_');
      
      // Create message
      final message = MessageModel(
        id: '',
        senderId: currentUserId,
        receiverId: receiverId,
        content: content,
        timestamp: DateTime.now(),
      );

      // Add message to chat room
      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .add(message.toMap());
          
      // Update chat room last message info
      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .set({
            'lastMessage': content,
            'lastMessageTime': FieldValue.serverTimestamp(),
            'participants': [currentUserId, receiverId],
            'participantEmails': [currentUserEmail, ''], // You might want to store receiver email too
			}, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  // Update message read status
  Future<void> markAsRead(String messageId, String chatRoomId) async {
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId)
        .update({'isRead': true});
  }

  // Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }
}