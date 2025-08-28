import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final bool isRead;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    this.type = MessageType.text,
    required this.timestamp,
    this.isRead = false,
  });

  factory MessageModel.fromMap(Map<String, dynamic> data, String id) {
    return MessageModel(
      id: id,
      senderId: data['senderId'],
      receiverId: data['receiverId'],
      content: data['content'],
      type: MessageType.values[data['type'] ?? 0],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'type': type.index,
      'timestamp': Timestamp.fromDate(timestamp), // 👈 store as Firestore Timestamp
      'isRead': isRead,
    };
  }
}

enum MessageType {
  text,
  image,
  file,
}
