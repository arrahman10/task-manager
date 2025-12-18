import 'package:flutter/material.dart';
import 'package:task_manager/core/constants/app_colors.dart';
import 'package:task_manager/core/constants/app_radius.dart';
import 'package:task_manager/core/constants/app_typography.dart';
import 'package:task_manager/core/widgets/app_snackbar.dart';
import 'package:task_manager/core/widgets/glass_container.dart';
import 'package:task_manager/core/widgets/primary_button.dart';
import 'package:task_manager/core/widgets/screen_background.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isSubmitting = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required.';
    }
    if (value.trim().length < 3) {
      return 'Please enter at least 3 characters.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required.';
    }
    const String pattern = r'^[^@]+@[^@]+\.[^@]+$';
    final RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value.trim())) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  String? _validateMobile(String? value) {
    final String text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Mobile is required.';
    }

    final RegExp bdLocalMobileRegExp = RegExp(r'^01\d{9}$');

    if (!bdLocalMobileRegExp.hasMatch(text)) {
      return 'Please enter a valid Bangladeshi mobile number (e.g. 01712345678).';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password.';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match.';
    }
    return null;
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required IconData icon,
    String? hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: AppColors.textSecondary,
      ),
      suffixIcon: suffixIcon,
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

      AppSnackbar.show(
        context: context,
        message: 'Registration successful (demo only).',
        type: AppSnackbarType.success,
        bottomOffset: 24,
      );

      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      AppSnackbar.show(
        context: context,
        message: 'Registration failed. Please try again.',
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
                        'Create your account',
                        style: AppTypography.h1,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Fill in the details below to sign up.',
                        style: AppTypography.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _nameController,
                        decoration: _buildInputDecoration(
                          label: 'Full name',
                          icon: Icons.person_outline,
                          hint: 'Enter your full name',
                        ),
                        textInputAction: TextInputAction.next,
                        validator: _validateName,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _emailController,
                        decoration: _buildInputDecoration(
                          label: 'Email',
                          icon: Icons.email_outlined,
                          hint: 'Enter your email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _mobileController,
                        decoration: _buildInputDecoration(
                          label: 'Mobile',
                          icon: Icons.phone_outlined,
                          hint: 'Enter your mobile number',
                        ),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        validator: _validateMobile,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _passwordController,
                        decoration: _buildInputDecoration(
                          label: 'Password',
                          icon: Icons.lock_outline,
                          hint: 'Create a password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                        ),
                        obscureText: !_isPasswordVisible,
                        textInputAction: TextInputAction.next,
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: _buildInputDecoration(
                          label: 'Confirm password',
                          icon: Icons.lock_outline,
                          hint: 'Re-enter your password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                        ),
                        obscureText: !_isConfirmPasswordVisible,
                        textInputAction: TextInputAction.done,
                        validator: _validateConfirmPassword,
                        onFieldSubmitted: (_) => _submit(),
                      ),
                      const SizedBox(height: 20),
                      PrimaryButton(
                        label: 'Sign Up',
                        onPressed: _submit,
                        isBusy: _isSubmitting,
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Already have an account? Log in'),
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
