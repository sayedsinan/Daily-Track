import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/home_screen.dart';
import '../screens/auth/login_screen.dart';

class AuthActions {
  static Future<void> signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signIn(email: email, password: password);

    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid email or password'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (success && context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  static Future<void> signUpUser({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signUp(name: name, email: email, password: password);

    if (success && context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign up failed. Email might already be in use.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  static Future<void> resetPassword({
    required BuildContext context,
    required String email,
    required String newPassword,
  }) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.resetPassword(email, newPassword);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Password reset successfully!' : 'Email not found.',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
      if (success) Navigator.pop(context);
    }
  }

  static Future<void> signOutUser(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.signOut();

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  static void showUserProfile(BuildContext context, AuthProvider authProvider) {
    final user = authProvider.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User data is loading.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('User Profile', style: TextStyle(color: Color(0xFF14B8A6))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, color: Color(0xFF14B8A6)),
                const SizedBox(width: 12),
                Text(user.name),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.email, color: Color(0xFF14B8A6)),
                const SizedBox(width: 12),
                Expanded(child: Text(user.email)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }
}
