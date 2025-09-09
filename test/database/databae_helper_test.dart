import 'package:daily_track/database/database_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DatabaseHelper Tests', () {
    test('should be a singleton', () {
      final dbHelper1 = DatabaseHelper();
      final dbHelper2 = DatabaseHelper();
      expect(identical(dbHelper1, dbHelper2), true);
    });

  });
}
