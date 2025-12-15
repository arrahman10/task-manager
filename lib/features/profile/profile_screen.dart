import 'package:flutter/material.dart';
import 'package:task_manager/session/session_manager.dart';
import 'package:task_manager/core/widgets/glass_container.dart';
import 'package:task_manager/core/widgets/screen_background.dart';
import 'package:task_manager/core/constants/app_colors.dart';
import 'package:task_manager/core/constants/app_radius.dart';
import 'package:task_manager/core/constants/app_typography.dart';
import 'package:task_manager/routing/route_names.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  List<String> _splitName(String fullName) {
    final String trimmed = fullName.trim();
    if (trimmed.isEmpty) return <String>['', ''];

    final List<String> parts = trimmed
        .split(RegExp(r'\s+'))
        .where((e) => e.trim().isNotEmpty)
        .toList();

    if (parts.isEmpty) return <String>['', ''];
    if (parts.length == 1) return <String>[parts.first, ''];

    final String first = parts.first;
    final String last = parts.sublist(1).join(' ');
    return <String>[first, last];
  }

  InputDecoration _fieldDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.textSecondary),
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide(
          color: AppColors.textMuted.withOpacity(0.25),
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide(
          color: AppColors.textMuted.withOpacity(0.25),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.4,
        ),
      ),
    );
  }

  Widget _readOnlyField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      showCursor: false,
      decoration: _fieldDecoration(label: label, icon: icon),
      style: AppTypography.body.copyWith(color: AppColors.textPrimary),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String name = SessionManager.userName ?? 'Demo User';
    final String email = SessionManager.userEmail ?? 'demo@taskmanager.app';
    final String mobile = (SessionManager.userMobile != null &&
            SessionManager.userMobile!.trim().isNotEmpty)
        ? SessionManager.userMobile!.trim()
        : 'Not set';

    final List<String> nameParts = _splitName(name);
    final String firstName = nameParts[0];
    final String lastName = nameParts[1];

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ScreenBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GlassContainer(
                  radius: 24,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        child: Icon(Icons.person_outline),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: Theme.of(context).textTheme.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              email,
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GlassContainer(
                  radius: 24,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Profile details',
                        style: AppTypography.h1,
                      ),
                      const SizedBox(height: 12),
                      _readOnlyField(
                        label: 'Email',
                        value: email,
                        icon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 12),
                      _readOnlyField(
                        label: 'First name',
                        value: firstName,
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 12),
                      _readOnlyField(
                        label: 'Last name',
                        value: lastName,
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 12),
                      _readOnlyField(
                        label: 'Mobile',
                        value: mobile,
                        icon: Icons.phone_outlined,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GlassContainer(
                  radius: 24,
                  padding: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () async {
                      await SessionManager.clearSession();
                      if (!context.mounted) return;
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RouteNames.login,
                        (_) => false,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
