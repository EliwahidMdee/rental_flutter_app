import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/validators.dart';
import '../providers/auth_provider.dart';
import '../../common/widgets/custom_button.dart';
import '../../common/widgets/custom_text_field.dart';

/// Forgot Password Screen
/// 
/// Allows users to reset their password

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleForgotPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final success = await ref.read(authStateProvider.notifier).forgotPassword(
          _emailController.text.trim(),
        );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      setState(() => _emailSent = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send reset email. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _emailSent ? _buildSuccessView() : _buildFormView(),
          ),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Icon
          Icon(
            Icons.lock_reset,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          
          // Title
          Text(
            'Forgot Password?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          
          // Subtitle
          Text(
            'Enter your email address and we\'ll send you instructions to reset your password.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 32),
          
          // Email Field
          CustomTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'Enter your email',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
          ),
          const SizedBox(height: 24),
          
          // Send Button
          CustomButton(
            text: 'Send Reset Link',
            onPressed: _isLoading ? null : _handleForgotPassword,
            isLoading: _isLoading,
            width: double.infinity,
          ),
          const SizedBox(height: 16),
          
          // Back to Login
          TextButton(
            onPressed: () => context.go('/login'),
            child: const Text('Back to Login'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Success Icon
        Icon(
          Icons.check_circle_outline,
          size: 80,
          color: Colors.green,
        ),
        const SizedBox(height: 24),
        
        // Title
        Text(
          'Check Your Email',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        
        // Message
        Text(
          'We\'ve sent password reset instructions to ${_emailController.text}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey,
              ),
        ),
        const SizedBox(height: 32),
        
        // Back to Login Button
        CustomButton(
          text: 'Back to Login',
          onPressed: () => context.go('/login'),
          width: double.infinity,
        ),
        const SizedBox(height: 16),
        
        // Resend Link
        TextButton(
          onPressed: () {
            setState(() => _emailSent = false);
          },
          child: const Text('Resend Email'),
        ),
      ],
    );
  }
}
