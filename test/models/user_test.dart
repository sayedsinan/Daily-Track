import 'package:daily_track/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User Model Tests', () {
    test('should create a user with correct properties', () {
      final user = User(
        id: 1,
        email: 'test@example.com',
        password: 'hashedpassword',
        name: 'Test User',
      );

      expect(user.id, 1);
      expect(user.email, 'test@example.com');
      expect(user.password, 'hashedpassword');
      expect(user.name, 'Test User');
      expect(user.createdAt, isA<DateTime>());
    });

    test('should convert user to map correctly', () {
      final user = User(
        id: 1,
        email: 'test@example.com',
        password: 'hashedpassword',
        name: 'Test User',
      );

      final map = user.toMap();

      expect(map['id'], 1);
      expect(map['email'], 'test@example.com');
      expect(map['password'], 'hashedpassword');
      expect(map['name'], 'Test User');
      expect(map['createdAt'], isA<String>());
    });

    test('should create user from map correctly', () {
      final map = {
        'id': 1,
        'email': 'test@example.com',
        'password': 'hashedpassword',
        'name': 'Test User',
        'createdAt': DateTime.now().toIso8601String(),
      };

      final user = User.fromMap(map);

      expect(user.id, 1);
      expect(user.email, 'test@example.com');
      expect(user.password, 'hashedpassword');
      expect(user.name, 'Test User');
    });

    test('should copy user with new values', () {
      final originalUser = User(
        id: 1,
        email: 'original@example.com',
        password: 'originalpassword',
        name: 'Original Name',
      );

      final copiedUser = originalUser.copyWith(
        email: 'new@example.com',
        name: 'New Name',
      );

      expect(copiedUser.id, 1);
      expect(copiedUser.email, 'new@example.com');
      expect(copiedUser.password, 'originalpassword');
      expect(copiedUser.name, 'New Name');
    });
  });
}
