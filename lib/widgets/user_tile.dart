import 'package:flutter/material.dart';
import 'package:appchatfl/models/user_model.dart';
import 'package:appchatfl/theme/app_theme.dart';

class UserTile extends StatelessWidget {
  final UserModel user;
  final VoidCallback onTap;

  const UserTile({
    super.key,
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: AppTheme.primaryBlue.withOpacity(0.2),
        backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
        child: user.avatarUrl == null
            ? Text(
                user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : 'U',
                style: const TextStyle(
                  color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
      title: Text(
        user.fullName,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        user.status,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: isDark ? Colors.white70 : Colors.grey.shade600,
          fontSize: 14,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (user.isOnline)
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppTheme.accentGreen,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? AppTheme.cardDark : Colors.white,
                  width: 2,
                ),
              ),
            ),
        ],
      ),
      onTap: onTap,
    );
  }
}