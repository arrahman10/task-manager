import 'package:flutter/material.dart';
import 'package:task_manager/core/constants/app_colors.dart';
import 'package:task_manager/core/constants/app_radius.dart';
import 'package:task_manager/core/constants/app_typography.dart';
import 'package:task_manager/core/widgets/app_snackbar.dart';
import 'package:task_manager/core/widgets/glass_container.dart';
import 'package:task_manager/core/widgets/primary_button.dart';
import 'package:task_manager/core/widgets/screen_background.dart';
import 'package:task_manager/routing/route_names.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController =
      TextEditingController(text: 'arrahman.lus@gmail.com');
  final TextEditingController _passwordController =
      TextEditingController(text: '123456@Tm');

  bool _isSubmitting = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  String? _validateEmail(String? value) {
    final String trimmed = (value ?? '').trim();

    if (trimmed.isEmpty) {
      return 'Email is required.';
    }

    const String pattern = r'^[^@]+@[^@]+\.[^@]+$';
    final RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(trimmed)) {
      return 'Enter a valid email address.';
    }

    return null;
  }

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

  // Demo-only submit (no real API yet)
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
        message: 'Logged in (demo only).',
        type: AppSnackbarType.success,
        bottomOffset: 24,
      );

      // Later step এ real Home screen আসবে
      Navigator.pushReplacementNamed(context, RouteNames.home);
    } catch (_) {
      if (!mounted) return;
      AppSnackbar.show(
        context: context,
        message: 'Login failed. Please try again.',
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
                      const SizedBox(height: 24),
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
                              context,
                              RouteNames.forgotPassword,
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            textStyle: AppTypography.caption,
                          ),
                          child: const Text('Forgot Password?'),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                          child: const Text(
                            'Don\'t have an account? Create one',
                          ),
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
