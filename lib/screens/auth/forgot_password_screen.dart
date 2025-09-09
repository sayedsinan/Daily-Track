import 'package:daily_track/utils/support.dart';
import 'package:daily_track/widgets/my_button.dart';
import 'package:daily_track/widgets/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final ValueNotifier<bool> _obscureNewPassword = ValueNotifier(true);
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
                    Icon(Icons.lock_reset, size: 64, color: Color(0xFF14B8A6)),
                    SizedBox(height: 16),
                    Text(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF14B8A6),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Enter your email and new password',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            
              Form(
                key: formKey,
                child: Column(
                  children: [
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
                      valueListenable: _obscureNewPassword,
                      builder: (context, obscure, _) {
                        return TextInputField(
                          label: 'Enter your new password',
                          controller: newPasswordController,
                          isPassword: true,
                          prefixIcon: Icons.lock_outline,
                          keyboard: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your new password';
                            }

                            return null;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    ValueListenableBuilder<bool>(
                      valueListenable: _obscureConfirmPassword,
                      builder: (context, obscure, _) {
                        return TextInputField(
                          label: 'Confirm your  password',
                          controller: confirmPasswordController,
                         isPassword: true,
                          prefixIcon: Icons.lock_outline,
                          keyboard: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Confirm your new password';
                            }
                            if (newPasswordController.text !=
                                confirmPasswordController.text) {
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
                          text: "Reset Password",
                          isLoading: authProvider.isLoading,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              AuthActions.resetPassword(
                                context: context,
                                email: emailController.text,
                                newPassword: newPasswordController.text,
                              );
                            }
                          },
                        );
                      },
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
