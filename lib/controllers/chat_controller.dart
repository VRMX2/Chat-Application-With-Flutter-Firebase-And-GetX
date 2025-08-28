// controllers/chat_controller.dart
import 'package:get/get.dart';
import 'package:appchatfl/services/chat_service.dart';
import 'package:appchatfl/models/user_model.dart';
import 'package:appchatfl/models/message_model.dart';

class ChatController extends GetxController {
  final ChatService _chatService = ChatService();

  // Reactive variables
  final RxList<UserModel> _users = <UserModel>[].obs;
  final RxList<MessageModel> _messages = <MessageModel>[].obs;
  final RxString _selectedUserId = ''.obs;
  final RxBool _isLoading = false.obs;
  final RxString _searchQuery = ''.obs;

  // Getters
  List<UserModel> get users => _users;
  List<MessageModel> get messages => _messages;
  String get selectedUserId => _selectedUserId.value;
  bool get isLoading => _isLoading.value;
  String get searchQuery => _searchQuery.value;

  // Filtered users based on search query
  List<UserModel> get filteredUsers {
    if (_searchQuery.isEmpty) return _users;
    return _users.where((user) => 
      user.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      user.email.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  // Set search query
  void setSearchQuery(String query) {
    _searchQuery.value = query;
  }

  // Load all users
  Future<void> loadUsers() async {
    try {
      _isLoading.value = true;
      _chatService.getUsers().listen((users) {
        _users.assignAll(users);
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to load users: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  // Load messages for a specific user
  Future<void> loadMessages(String userId) async {
    try {
      _isLoading.value = true;
      _selectedUserId.value = userId;
      _chatService.getMessages(userId).listen((messages) {
        _messages.assignAll(messages);
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to load messages: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  // Send a message
  Future<void> sendMessage(String content) async {
    try {
      if (content.trim().isEmpty) return;
      
      await _chatService.sendMessage(_selectedUserId.value, content.trim());
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message: $e');
    }
  }

  // Clear selected user and messages
  void clearChat() {
    _selectedUserId.value = '';
    _messages.clear();
  }
}