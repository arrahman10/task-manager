import 'package:flutter/material.dart';
import 'package:task_manager/core/constants/app_colors.dart';
import 'package:task_manager/core/constants/app_radius.dart';
import 'package:task_manager/core/constants/app_typography.dart';
import 'package:task_manager/core/widgets/app_snackbar.dart';
import 'package:task_manager/core/widgets/glass_container.dart';
import 'package:task_manager/core/widgets/primary_button.dart';
import 'package:task_manager/core/widgets/screen_background.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.code,
  });

  final String email;
  final String code;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isSubmitting = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration({
    required String label,
    String? hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.2,
        ),
      ),
      suffixIcon: suffixIcon,
    );
  }

  String? _validatePassword(String? value) {
    final String text = (value ?? '').trim();

    if (text.isEmpty) {
      return 'Password is required.';
    }

    if (text.length < 6) {
      return 'Password must be at least 6 characters.';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final String text = (value ?? '').trim();

    if (text.isEmpty) {
      return 'Please confirm your password.';
    }

    if (text != _passwordController.text.trim()) {
      return 'Passwords do not match.';
    }

    return null;
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Simulate a short network delay for demo purposes.
      await Future<void>.delayed(const Duration(milliseconds: 900));

      if (!mounted) return;

      AppSnackbar.show(
        context: context,
        message: 'Password reset (demo only).',
        type: AppSnackbarType.success,
        bottomOffset: 24,
      );

      // For now, just go back to the previous screen.
      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      AppSnackbar.show(
        context: context,
        message: 'Failed to reset password. Please try again.',
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
    return Scaffold(
      body: ScreenBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: GlassContainer(
                radius: 28,
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text(
                        'Set new password',
                        style: AppTypography.h1,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Choose a new password for ${widget.email}.\n'
                        'This is a demo flow – no real account will be updated.',
                        style: AppTypography.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _passwordController,
                        decoration: _buildInputDecoration(
                          label: 'New password',
                          hint: 'Enter a new password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.next,
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: _buildInputDecoration(
                          label: 'Confirm password',
                          hint: 'Re-enter the new password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                        obscureText: _obscureConfirmPassword,
                        textInputAction: TextInputAction.done,
                        validator: _validateConfirmPassword,
                        onFieldSubmitted: (_) => _submit(),
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        label: 'Reset password',
                        onPressed: _submit,
                        isBusy: _isSubmitting,
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.textSecondary,
                            textStyle: AppTypography.body,
                          ),
                          child: const Text('Back'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
