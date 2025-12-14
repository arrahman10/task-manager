import 'package:flutter/material.dart';
import 'package:task_manager/core/constants/app_colors.dart';
import 'package:task_manager/core/constants/app_typography.dart';
import 'package:task_manager/core/widgets/primary_button.dart';
import 'package:task_manager/core/widgets/screen_background.dart';
import 'package:task_manager/core/widgets/app_snackbar.dart';
import 'package:task_manager/features/auth/reset_password_screen.dart';

class ForgotPasswordOtpScreen extends StatefulWidget {
  final String email;

  const ForgotPasswordOtpScreen({
    super.key,
    required this.email,
  });

  @override
  State<ForgotPasswordOtpScreen> createState() =>
      _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  String? _validateCode(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Code is required.';
    }
    if (text.length < 4) {
      return 'Please enter the 4-digit code.';
    }
    return null;
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Demo delay instead of real API call
      await Future<void>.delayed(const Duration(milliseconds: 800));

      if (!mounted) return;

      final code = _otpController.text.trim();

      AppSnackbar.show(
        context: context,
        message: 'Code verified (demo only). You can now set a new password.',
        type: AppSnackbarType.success,
        bottomOffset: 24,
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(
            email: widget.email,
            otp: code,
          ),
        ),
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Verify code',
                      style: AppTypography.h1,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We have sent a verification code to ${widget.email}. '
                      'Enter the code to continue.',
                      style: AppTypography.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _otpController,
                      decoration: InputDecoration(
                        labelText: 'Verification code',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      validator: _validateCode,
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: 'Verify code',
                      onPressed: _submit,
                      isBusy: _isSubmitting,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
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
    );
  }
}
