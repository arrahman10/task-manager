import 'package:flutter/material.dart';
import 'package:task_manager/core/constants/app_colors.dart';
import 'package:task_manager/core/constants/app_radius.dart';
import 'package:task_manager/core/constants/app_typography.dart';
import 'package:task_manager/core/widgets/app_snackbar.dart';
import 'package:task_manager/core/widgets/glass_container.dart';
import 'package:task_manager/core/widgets/primary_button.dart';
import 'package:task_manager/core/widgets/screen_background.dart';
import 'package:task_manager/features/auth/reset_password_screen.dart';

class ForgotPasswordOtpScreen extends StatefulWidget {
  const ForgotPasswordOtpScreen({
    super.key,
    required this.email,
  });

  final String email;

  @override
  State<ForgotPasswordOtpScreen> createState() =>
      _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  String? _validateCode(String? value) {
    final String text = (value ?? '').trim();
    if (text.isEmpty) {
      return 'Code is required.';
    }
    if (text.length < 4) {
      return 'Code must be at least 4 characters.';
    }
    return null;
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      labelText: 'Verification code',
      hintText: 'Enter the code you received',
      prefixIcon: Icon(
        Icons.lock_clock_outlined,
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

      final String code = _codeController.text.trim();

      AppSnackbar.show(
        context: context,
        message: 'Code verified (demo only).',
        type: AppSnackbarType.success,
        bottomOffset: 24,
      );

      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ResetPasswordScreen(email: widget.email, code: code),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      AppSnackbar.show(
        context: context,
        message: 'Failed to verify code. Please try again.',
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
                        'Enter verification code',
                        style: AppTypography.h1,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We have sent a code to ${widget.email}. '
                        'This is a demo flow – no real email was sent.',
                        style: AppTypography.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _codeController,
                        decoration: _buildInputDecoration(),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        validator: _validateCode,
                        onFieldSubmitted: (_) => _submit(),
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        label: 'Continue',
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
      ),
    );
  }
}
