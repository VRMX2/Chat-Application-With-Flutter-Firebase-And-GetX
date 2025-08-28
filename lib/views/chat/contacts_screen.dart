// views/chat/contacts_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appchatfl/controllers/chat_controller.dart';
import 'package:appchatfl/widgets/user_tile.dart';
import 'package:appchatfl/views/chat/chat_screen.dart';

class ContactsScreen extends StatelessWidget {
  ContactsScreen({super.key});
  
  final TextEditingController _searchController = TextEditingController();
  final ChatController _chatController = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          IconButton(
            onPressed: () {
              // Refresh contacts
              _chatController.loadUsers();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onChanged: (value) {
                _chatController.setSearchQuery(value);
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (_chatController.isLoading && _chatController.users.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (_chatController.filteredUsers.isEmpty) {
                return const Center(
                  child: Text('No contacts found'),
                );
              }
              
              return ListView.builder(
                itemCount: _chatController.filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = _chatController.filteredUsers[index];
                  return UserTile(
                    user: user,
                    onTap: () {
                      Get.to(() => ChatScreen(user: user));
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}