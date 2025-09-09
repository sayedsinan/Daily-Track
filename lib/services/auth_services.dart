import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_helper.dart';
import '../models/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final DatabaseHelper _dbHelper = DatabaseHelper();
  static const String _userIdKey = 'user_id';
  static const String _isLoggedInKey = 'is_logged_in';

  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final existingUser = await _dbHelper.getUserByEmail(email);
      if (existingUser != null) {
        return false;
      }
      final hashedPassword = _hashPassword(password);
      final user = User(email: email, password: hashedPassword, name: name);

      final userId = await _dbHelper.createUser(user);

      return userId > 0;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    try {
      final user = await _dbHelper.getUserByEmail(email);
      if (user == null) {
        return false;
      }

      final hashedPassword = _hashPassword(password);
      if (user.password == hashedPassword) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(_userIdKey, user.id!);
        await prefs.setBool(_isLoggedInKey, true);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<int?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  Future<User?> getCurrentUser() async {
    final userId = await getCurrentUserId();
    if (userId != null) {
      return await _dbHelper.getUserById(userId);
    }
    return null;
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  Future<bool> resetPassword(String email, String newPassword) async {
    try {
      final user = await _dbHelper.getUserByEmail(email);
      if (user == null) {
        return false;
      }

      final hashedPassword = _hashPassword(newPassword);
      final updatedUser = user.copyWith(password: hashedPassword);

      final db = await _dbHelper.database;
      final result = await db.update(
        'users',
        updatedUser.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
      return result > 0;
    } catch (e) {
      return false;
    }
  }
}
