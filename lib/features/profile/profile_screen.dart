import 'package:flutter/material.dart';
import 'package:task_manager/core/constants/app_colors.dart';
import 'package:task_manager/core/constants/app_radius.dart';
import 'package:task_manager/core/constants/app_typography.dart';
import 'package:task_manager/core/widgets/app_snackbar.dart';
import 'package:task_manager/core/widgets/glass_container.dart';
import 'package:task_manager/core/widgets/primary_button.dart';
import 'package:task_manager/core/widgets/screen_background.dart';
import 'package:task_manager/data/remote/auth_api.dart';
import 'package:task_manager/session/session_manager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthApi _authApi = AuthApi();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _prefillFromSession();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _prefillFromSession() {
    final String fullName = (SessionManager.userName ?? '').trim();
    final String firstName = (SessionManager.userFirstName ?? '').trim();
    final String lastName = (SessionManager.userLastName ?? '').trim();

    if (firstName.isNotEmpty || lastName.isNotEmpty) {
      _firstNameController.text = firstName;
      _lastNameController.text = lastName;
    } else {
      final List<String> parts = fullName
          .split(RegExp(r'\s+'))
          .where((String e) => e.trim().isNotEmpty)
          .toList();

      if (parts.isEmpty) {
        _firstNameController.text = '';
        _lastNameController.text = '';
      } else if (parts.length == 1) {
        _firstNameController.text = parts.first;
        _lastNameController.text = '';
      } else {
        _firstNameController.text = parts.first;
        _lastNameController.text = parts.sublist(1).join(' ');
      }
    }

    _mobileController.text = (SessionManager.userMobile ?? '').trim();
  }

  String _buildFullName(String firstName, String lastName) {
    final String fn = firstName.trim();
    final String ln = lastName.trim();
    return <String>[fn, ln].where((String e) => e.isNotEmpty).join(' ').trim();
  }

  InputDecoration _fieldDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.textSecondary),
      suffixIcon: suffixIcon,
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

  String? _validateFirstName(String? value) {
    final String text = value?.trim() ?? '';
    if (text.isEmpty) return 'First name is required.';
    if (text.length < 2) return 'Please enter at least 2 characters.';
    return null;
  }

  String? _validateLastName(String? value) {
    final String text = value?.trim() ?? '';
    if (text.isEmpty) return 'Last name is required.';
    if (text.length < 2) return 'Please enter at least 2 characters.';
    return null;
  }

  String? _validateMobile(String? value) {
    final String text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Mobile is required.';
    }

    // Only allow 11-digit Bangladeshi mobile in local format: 01XXXXXXXXX
    final RegExp bdLocalMobileRegExp = RegExp(r'^01\d{9}$');

    if (!bdLocalMobileRegExp.hasMatch(text)) {
      return 'Please enter a valid Bangladeshi mobile number (e.g. 01712345678).';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    final String text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    if (text.length < 6) return 'Password must be at least 6 characters.';
    return null;
  }

  Future<void> _submitUpdate() async {
    if (_isSubmitting) return;

    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final String? token = SessionManager.authToken?.trim();
    if (token == null || token.isEmpty) {
      AppSnackbar.show(
        context: context,
        message: 'Session not found. Please log in again.',
        type: AppSnackbarType.error,
        bottomOffset: 24,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final String firstName = _firstNameController.text.trim();
      final String lastName = _lastNameController.text.trim();
      final String mobile = _mobileController.text.trim();
      final String password = _passwordController.text.trim();

      await _authApi.updateProfile(
        firstName: firstName,
        lastName: lastName,
        mobile: mobile,
        password: password.isEmpty ? null : password,
      );

      final String email = (SessionManager.userEmail ?? '').trim();
      final String fullName = _buildFullName(firstName, lastName);

      await SessionManager.saveDemoSession(
        token: token,
        name: fullName,
        email: email,
        mobile: mobile,
        firstName: firstName,
        lastName: lastName,
      );

      if (!mounted) return;

      AppSnackbar.show(
        context: context,
        message: 'Profile updated successfully.',
        type: AppSnackbarType.success,
        bottomOffset: 24,
      );

      _passwordController.clear();
      setState(() {});
    } on ApiException catch (e) {
      if (!mounted) return;
      AppSnackbar.show(
        context: context,
        message: e.message,
        type: AppSnackbarType.error,
        bottomOffset: 24,
      );
    } catch (_) {
      if (!mounted) return;
      AppSnackbar.show(
        context: context,
        message: 'Failed to update profile. Please try again.',
        type: AppSnackbarType.error,
        bottomOffset: 24,
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String email =
        (SessionManager.userEmail ?? 'demo@taskmanager.app').trim();

    final String computedName =
        _buildFullName(_firstNameController.text, _lastNameController.text);

    final String fallbackName = (SessionManager.userName ?? 'Demo User').trim();

    final String fullName =
        computedName.isNotEmpty ? computedName : fallbackName;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ScreenBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                GlassContainer(
                  radius: 24,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: <Widget>[
                      const CircleAvatar(
                        radius: 28,
                        child: Icon(Icons.person_outline),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              fullName.isEmpty ? 'Demo User' : fullName,
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const Text(
                          'Profile details',
                          style: AppTypography.h1,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          initialValue: email,
                          readOnly: true,
                          showCursor: false,
                          decoration: _fieldDecoration(
                            label: 'Email',
                            icon: Icons.email_outlined,
                          ),
                          style: AppTypography.body.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _firstNameController,
                          decoration: _fieldDecoration(
                            label: 'First name',
                            icon: Icons.person_outline,
                          ),
                          textInputAction: TextInputAction.next,
                          validator: _validateFirstName,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _lastNameController,
                          decoration: _fieldDecoration(
                            label: 'Last name',
                            icon: Icons.person_outline,
                          ),
                          textInputAction: TextInputAction.next,
                          validator: _validateLastName,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _mobileController,
                          decoration: _fieldDecoration(
                            label: 'Mobile',
                            icon: Icons.phone_outlined,
                          ),
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          validator: _validateMobile,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passwordController,
                          decoration: _fieldDecoration(
                            label: 'Password (optional)',
                            icon: Icons.lock_outline,
                          ),
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          validator: _validatePassword,
                          onFieldSubmitted: (_) => _submitUpdate(),
                        ),
                        const SizedBox(height: 16),
                        PrimaryButton(
                          label: 'Update',
                          onPressed: _submitUpdate,
                          isBusy: _isSubmitting,
                        ),
                      ],
                    ),
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
