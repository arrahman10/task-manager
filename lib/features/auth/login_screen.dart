import 'package:flutter/material.dart';
import 'package:task_manager/core/constants/app_colors.dart';
import 'package:task_manager/core/constants/app_radius.dart';
import 'package:task_manager/core/constants/app_typography.dart';
import 'package:task_manager/core/widgets/app_snackbar.dart';
import 'package:task_manager/core/widgets/primary_button.dart';
import 'package:task_manager/core/widgets/screen_background.dart';
import 'package:task_manager/routing/route_names.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Global form key to manage validation state
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers for email and password text fields
  final _emailController =
      TextEditingController(text: 'arrahman.lus@gmail.com');
  final _passwordController = TextEditingController(text: '123456@™');

  // Local UI state for submit and password visibility
  bool _isSubmitting = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    // Dispose controllers when widget is destroyed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Toggle password visibility for the password field
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  // Validate email input value
  String? _validateEmail(String? value) {
    final String trimmed = (value ?? '').trim();

    if (trimmed.isEmpty) {
      return 'Email is required.';
    }

    // Very small regex for basic email validation
    const String pattern = r'^[^@]+@[^@]+\.[^@]+$';
    final RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(trimmed)) {
      return 'Enter a valid email address.';
    }

    return null;
  }

  // Validate password input value
  String? _validatePassword(String? value) {
    final String trimmed = (value ?? '').trim();

    if (trimmed.isEmpty) {
      return 'Password is required.';
    }

    if (trimmed.length < 6) {
      return 'Password must be at least 6 characters.';
    }

    return null;
  }

  // Build a consistent input decoration for all text fields
  InputDecoration _buildInputDecoration({
    required String label,
    required String hint,
    required IconData icon,
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
    );
  }

  // Submit handler for the login button
  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }

    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // No real API yet, only a small delay to show the loader
      await Future<void>.delayed(const Duration(milliseconds: 600));

      if (!mounted) {
        return;
      }

      // Demo: pretend login is successful
      AppSnackbar.show(
        context: context,
        message:
        'Logged in successfully (demo only, API is not connected yet).',
        type: AppSnackbarType.success,
        bottomOffset: 24,
      );

      Navigator.pushReplacementNamed(context, RouteNames.home);

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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 24),
                    const Text(
                      'Welcome to Task Manager',
                      style: AppTypography.h1,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in with your email and password to continue.',
                      style: AppTypography.body.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Email field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: _buildInputDecoration(
                        label: 'Email',
                        hint: 'Enter your email',
                        icon: Icons.email_outlined,
                      ),
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      decoration: _buildInputDecoration(
                        label: 'Password',
                        hint: 'Enter your password',
                        icon: Icons.lock_outline,
                        suffixIcon: IconButton(
                          onPressed: _togglePasswordVisibility,
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                      validator: _validatePassword,
                      onFieldSubmitted: (_) => _submit(),
                    ),

                    const SizedBox(height: 8),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, RouteNames.forgotPassword);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          textStyle: AppTypography.caption,
                        ),
                        child: const Text('Forgot Password?'),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Primary login button with loader
                    PrimaryButton(
                      label: 'Log In',
                      onPressed: _submit,
                      isBusy: _isSubmitting,
                    ),

                    const SizedBox(height: 12),

                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RouteNames.register);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          textStyle: AppTypography.body,
                        ),
                        child: const Text('Don\'t have an account? Create one'),
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
