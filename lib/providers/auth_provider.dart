import 'package:daily_track/services/auth_services.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    final isLoggedIn = await _authService.isLoggedIn();
    if (isLoggedIn) {
      _currentUser = await _authService.getCurrentUser();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    _isLoading = true;
    notifyListeners();

    final success = await _authService.signUp(
      email: email,
      password: password,
      name: name,
    );

    if (success) {
     
      await signIn(email: email, password: password);
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<bool> signIn({required String email, required String password}) async {
    _isLoading = true;
    notifyListeners();

    final success = await _authService.signIn(email: email, password: password);

    if (success) {
      _currentUser = await _authService.getCurrentUser();
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }

  Future<bool> resetPassword(String email, String newPassword) async {
    _isLoading = true;
    notifyListeners();

    final success = await _authService.resetPassword(email, newPassword);

    _isLoading = false;
    notifyListeners();
    return success;
  }
}
