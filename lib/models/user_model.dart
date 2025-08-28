import 'package:cloud_firestore/cloud_firestore.dart';
class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final String? avatarUrl;
  final String status;
  final bool isOnline;
  final DateTime lastSeen;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    this.avatarUrl,
    this.status = 'Hey there! I am using Chat App 2026',
    this.isOnline = false,
    required this.lastSeen,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String id) {
    return UserModel(
      uid: id,
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      avatarUrl: data['avatarUrl'],
      status: data['status'] ?? 'Hey there! I am using Chat App 2026',
      isOnline: data['isOnline'] ?? false,
      lastSeen: (data['lastSeen'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'avatarUrl': avatarUrl,
      'status': status,
      'isOnline': isOnline,
      'lastSeen': lastSeen,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}