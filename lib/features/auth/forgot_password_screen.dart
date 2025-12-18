import 'package:flutter/material.dart';
import 'package:task_manager/core/constants/app_colors.dart';
import 'package:task_manager/core/constants/app_radius.dart';
import 'package:task_manager/core/constants/app_typography.dart';
import 'package:task_manager/core/widgets/app_snackbar.dart';
import 'package:task_manager/core/widgets/glass_container.dart';
import 'package:task_manager/core/widgets/primary_button.dart';
import 'package:task_manager/core/widgets/screen_background.dart';
import 'package:task_manager/features/auth/forgot_password_otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required.';
    }
    const String pattern = r'^[^@]+@[^@]+\.[^@]+$';
    final RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value.trim())) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        icon,
        color: AppColors.textSecondary,
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.82),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.70),
          width: 1.1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.55),
          width: 1.0,
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
          width: 1.0,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.2,
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await Future<void>.delayed(const Duration(milliseconds: 900));

      if (!mounted) return;

      final String email = _emailController.text.trim();

      AppSnackbar.show(
        context: context,
        message: 'We have sent a verification code to your email (demo only).',
        type: AppSnackbarType.success,
        bottomOffset: 24,
      );

      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ForgotPasswordOtpScreen(email: email),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      AppSnackbar.show(
        context: context,
        message: 'Failed to send verification code. Please try again.',
        type: AppSnackbarType.error,
        bottomOffset: 24,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
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
                        'Forgot password',
                        style: AppTypography.h1,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter your email address and we will send a verification code (demo only).',
                        style: AppTypography.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _emailController,
                        decoration: _buildInputDecoration(
                          label: 'Email',
                          icon: Icons.email_outlined,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        validator: _validateEmail,
                        onFieldSubmitted: (_) => _submit(),
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        label: 'Send reset link',
                        onPressed: _submit,
                        isBusy: _isSubmitting,
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Back to login'),
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
