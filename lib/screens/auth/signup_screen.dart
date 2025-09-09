import 'package:daily_track/utils/support.dart';
import 'package:daily_track/widgets/my_button.dart';
import 'package:daily_track/widgets/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final ValueNotifier<bool> _obscurePassword = ValueNotifier(true);
    final ValueNotifier<bool> _obscureConfirmPassword = ValueNotifier(true);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF14B8A6)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF14B8A6),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Sign up to get started',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    // Name Field
                    TextInputField(
                      label: 'Full Name',
                      controller: nameController,
                      prefixIcon: Icons.person_outlined,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Email Field
                    TextInputField(
                      label: 'Email',
                      controller: emailController,
                      prefixIcon: Icons.email_outlined,
                      keyboard: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                 
                    ValueListenableBuilder<bool>(
                      valueListenable: _obscurePassword,
                      builder: (context, obscure, _) {
                        return TextInputField(
                          label: 'Password',

                          controller: passwordController,
                          isPassword: true,
                          prefixIcon: Icons.lock_outlined,
                      
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    // Confirm Password Field
                    ValueListenableBuilder<bool>(
                      valueListenable: _obscureConfirmPassword,
                      builder: (context, obscure, _) {
                        return TextInputField(
                          label: 'Confirm Password',
                          controller: confirmPasswordController,
                          isPassword: true,
                          prefixIcon: Icons.lock_outlined,
                        
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return CustomButton(
                          text: "Sign Up",
                          isLoading: authProvider.isLoading,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              AuthActions.signUpUser(
                                context: context,
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Color(0xFF14B8A6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
