import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appchatfl/controllers/auth_controller.dart';
import 'package:appchatfl/theme/app_theme.dart';
import 'package:appchatfl/routes/app_routes.dart';
import 'package:appchatfl/models/user_model.dart';
import 'package:appchatfl/views/chat/contacts_screen.dart';
import 'package:appchatfl/views/chat/profile_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with TickerProviderStateMixin {
  final AuthController authController = Get.find<AuthController>();
  late AnimationController _animationController;
  late AnimationController _fabController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Search functionality
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchActive = false;

  // Demo chat data
  final List<Map<String, dynamic>> _chats = [
    {
      'name': 'Alice Johnson',
      'message': 'Hey! How are you doing today? 😊',
      'time': '2 min ago',
      'unread': 3,
      'isOnline': true,
      'avatar': 'AJ',
      'color': AppTheme.primaryBlue,
    },
    {
      'name': 'Bob Smith',
      'message': 'Let\'s meet tomorrow for coffee',
      'time': '1 hour ago',
      'unread': 0,
      'isOnline': true,
      'avatar': 'BS',
      'color': AppTheme.accentGreen,
    },
    {
      'name': 'Carol Williams',
      'message': 'Thanks for your help with the project!',
      'time': '3 hours ago',
      'unread': 1,
      'isOnline': false,
      'avatar': 'CW',
      'color': AppTheme.accentPink,
    },
    {
      'name': 'David Brown',
      'message': 'See you later! Have a great day',
      'time': 'Yesterday',
      'unread': 0,
      'isOnline': false,
      'avatar': 'DB',
      'color': AppTheme.primaryPurple,
    },
    {
      'name': 'Emma Davis',
      'message': 'The meeting was really productive',
      'time': '2 days ago',
      'unread': 0,
      'isOnline': true,
      'avatar': 'ED',
      'color': AppTheme.accentCyan,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fabController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _startAnimations() {
    _animationController.forward();
    _fabController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, isDark),
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        _buildSearchBar(context, isDark),
                        _buildQuickActions(context, isDark),
                        _buildChatsList(context, isDark),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(context, isDark),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildSliverAppBar(BuildContext context, bool isDark) {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: true,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
              AppTheme.surfaceDark,
              AppTheme.cardDark,
              AppTheme.primaryBlue.withOpacity(0.1),
            ]
                : [
              AppTheme.surfaceLight,
              AppTheme.cardLight,
              AppTheme.primaryBlue.withOpacity(0.05),
            ],
          ),
        ),
        child: FlexibleSpaceBar(
          titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
          title: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Chat App 2026",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                ),
              ),
              Text(
                "Welcome back, ${_getDisplayName()}!",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white70 : Colors.grey.shade600,
                ),
              ),
            ],
          )),
          background: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryBlue.withOpacity(0.1),
                  AppTheme.primaryPurple.withOpacity(0.05),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => _showThemeDialog(context),
          icon: Icon(
            isDark ? Icons.light_mode : Icons.dark_mode,
            color: isDark ? Colors.white70 : Colors.grey.shade600,
          ),
        ),
        PopupMenuButton<String>(
          onSelected: _handleMenuSelection,
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.more_vert,
              color: AppTheme.primaryBlue,
            ),
          ),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  Icon(Icons.person_outline),
                  SizedBox(width: 12),
                  Text('Profile'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.settings_outlined),
                  SizedBox(width: 12),
                  Text('Settings'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'help',
              child: Row(
                children: [
                  Icon(Icons.help_outline),
                  SizedBox(width: 12),
                  Text('Help & Feedback'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, color: Colors.red),
                  SizedBox(width: 12),
                  Text('Logout', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context, bool isDark) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: AppTheme.modernCard(isDark: isDark),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search conversations...',
          prefixIcon: Icon(
            Icons.search,
            color: AppTheme.primaryBlue,
          ),
          suffixIcon: _isSearchActive
              ? IconButton(
            onPressed: () {
              _searchController.clear();
              setState(() => _isSearchActive = false);
            },
            icon: const Icon(Icons.clear),
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
        onChanged: (value) {
          setState(() => _isSearchActive = value.isNotEmpty);
        },
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, bool isDark) {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildQuickAction(
            context,
            isDark,
            icon: Icons.person_add,
            label: 'Add Friend',
            color: AppTheme.accentGreen,
            onTap: () => _showSnackbar('Add Friend feature coming soon!'),
          ),
          _buildQuickAction(
            context,
            isDark,
            icon: Icons.group_add,
            label: 'New Group',
            color: AppTheme.primaryPurple,
            onTap: () => _showSnackbar('Create Group feature coming soon!'),
          ),
          _buildQuickAction(
            context,
            isDark,
            icon: Icons.qr_code_scanner,
            label: 'Scan QR',
            color: AppTheme.accentCyan,
            onTap: () => _showSnackbar('QR Scanner coming soon!'),
          ),
          _buildQuickAction(
            context,
            isDark,
            icon: Icons.archive,
            label: 'Archived',
            color: AppTheme.accentPink,
            onTap: () => _showSnackbar('Archived chats coming soon!'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
      BuildContext context,
      bool isDark, {
        required IconData icon,
        required String label,
        required Color color,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 16),
        decoration: AppTheme.modernCard(isDark: isDark),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatsList(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Chats",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () => _showSnackbar('View All coming soon!'),
                child: Text(
                  "View All",
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _chats.length,
          itemBuilder: (context, index) {
            final chat = _chats[index];
            return _buildChatItem(context, isDark, chat, index);
          },
        ),
        const SizedBox(height: 100), // Space for FAB
      ],
    );
  }

  Widget _buildChatItem(BuildContext context, bool isDark, Map<String, dynamic> chat, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: AppTheme.modernCard(isDark: isDark),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Stack(
          children: [
            Hero(
              tag: 'avatar_$index',
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: chat['color'],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: chat['color'].withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    chat['avatar'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            if (chat['isOnline'])
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? AppTheme.cardDark : AppTheme.cardLight,
                      width: 2,
                    ),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          chat['name'],
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            chat['message'],
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.grey.shade600,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              chat['time'],
              style: TextStyle(
                color: isDark ? Colors.white54 : Colors.grey.shade500,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            if (chat['unread'] > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  chat['unread'].toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
        onTap: () => _openChatScreen(context, chat),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context, bool isDark) {
    return ScaleTransition(
      scale: _fabController,
      child: FloatingActionButton.extended(
        onPressed: () => _showNewChatOptions(context, isDark),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 8,
        icon: const Icon(Icons.add),
        label: const Text(
          'New Chat',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // Helper methods
  String _getDisplayName() {
    return authController.user?.displayName?.split(' ').first ??
        authController.user?.email?.split('@').first ??
        'User';
  }

	void _handleMenuSelection(String value) {
  switch (value) {
    case 'profile':
      Get.toNamed(AppRoutes.profile);
      break;
    case 'contacts':
      Get.toNamed(AppRoutes.contacts);
      break;
    case 'settings':
      _showSnackbar('Settings coming soon!');
      break;
    case 'help':
      _showSnackbar('Help & Feedback coming soon!');
      break;
    case 'logout':
      _showLogoutDialog(Get.context!);
      break;
  }
}

  void _showThemeDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Theme Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.brightness_auto),
              title: const Text('System'),
              onTap: () {
                Get.changeThemeMode(ThemeMode.system);
                Get.back();
                _showSnackbar('Theme set to System');
              },
            ),
            ListTile(
              leading: const Icon(Icons.light_mode),
              title: const Text('Light'),
              onTap: () {
                Get.changeThemeMode(ThemeMode.light);
                Get.back();
                _showSnackbar('Light theme enabled');
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Dark'),
              onTap: () {
                Get.changeThemeMode(ThemeMode.dark);
                Get.back();
                _showSnackbar('Dark theme enabled');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showNewChatOptions(BuildContext context, bool isDark) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.cardDark : AppTheme.cardLight,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Start New Conversation',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildBottomSheetOption(
                    icon: Icons.person_add,
                    title: 'New Chat',
                    subtitle: 'Start a conversation with a friend',
                    color: AppTheme.primaryBlue,
                    onTap: () {
                      Get.back();
                      _showSnackbar('New Chat feature coming soon!');
                    },
                  ),
                  _buildBottomSheetOption(
                    icon: Icons.group_add,
                    title: 'New Group',
                    subtitle: 'Create a group conversation',
                    color: AppTheme.primaryPurple,
                    onTap: () {
                      Get.back();
                      _showSnackbar('Create Group feature coming soon!');
                    },
                  ),
                  _buildBottomSheetOption(
                    icon: Icons.contacts,
                    title: 'From Contacts',
                    subtitle: 'Choose from your contacts',
                    color: AppTheme.accentGreen,
                    onTap: () {
                      Get.back();
                      _showSnackbar('Contacts feature coming soon!');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }

	void _openChatScreen(BuildContext context, Map<String, dynamic> chat) {
  // Create a mock user for demo purposes
  final demoUser = UserModel(
    uid: 'demo_${chat['name'].toLowerCase()}',
    email: '${chat['name'].toLowerCase()}@example.com',
    fullName: chat['name'],
    avatarUrl: null,
    status: chat['message'],
    isOnline: chat['isOnline'],
    lastSeen: DateTime.now(),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
  
  Get.toNamed(AppRoutes.chat, arguments: demoUser);
}

  void _showProfileDialog(BuildContext context) {
    final TextEditingController displayNameController = TextEditingController(
      text: authController.user?.displayName ?? '',
    );
    final TextEditingController statusController = TextEditingController(
      text: 'Hey there! I am using Chat App 2026',
    );

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Edit Profile"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: AppTheme.primaryBlue,
                backgroundImage: authController.user?.photoURL != null
                    ? NetworkImage(authController.user!.photoURL!)
                    : null,
                child: authController.user?.photoURL == null
                    ? Text(
                  _getDisplayName()[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                )
                    : null,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: displayNameController,
                decoration: const InputDecoration(
                  labelText: "Display Name",
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: statusController,
                decoration: const InputDecoration(
                  labelText: "Status",
                  prefixIcon: Icon(Icons.info_outline),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Text(
                "Email: ${authController.user?.email ?? 'N/A'}",
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              authController.updateProfile(
                displayName: displayNameController.text.trim(),
                status: statusController.text.trim(),
              );
              Get.back();
              _showSnackbar('Profile updated successfully!');
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              authController.signOut();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSnackbar(String message) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppTheme.primaryBlue.withOpacity(0.9),
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
    );
  }
}