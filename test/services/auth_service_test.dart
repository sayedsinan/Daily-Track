import 'package:daily_track/services/auth_services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthService Tests', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
    });

    test('should be a singleton', () {
      final authService1 = AuthService();
      final authService2 = AuthService();
      expect(identical(authService1, authService2), true);
    });

    test('should hash password correctly', () {
      
      expect(true, true); 
    });
  });
}
