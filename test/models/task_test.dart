import 'package:daily_track/models/task.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Task Model Tests', () {
    test('should create a task with correct properties', () {
      final task = Task(
        id: 1,
        title: 'Test Task',
        description: 'Test Description',
        userId: 1,
      );

      expect(task.id, 1);
      expect(task.title, 'Test Task');
      expect(task.description, 'Test Description');
      expect(task.isCompleted, false);
      expect(task.userId, 1);
      expect(task.createdAt, isA<DateTime>());
    });

    test('should create a completed task', () {
      final task = Task(
        id: 1,
        title: 'Test Task',
        description: 'Test Description',
        isCompleted: true,
        userId: 1,
        completedAt: DateTime.now(),
      );

      expect(task.isCompleted, true);
      expect(task.completedAt, isA<DateTime>());
    });

    test('should convert task to map correctly', () {
      final task = Task(
        id: 1,
        title: 'Test Task',
        description: 'Test Description',
        userId: 1,
      );

      final map = task.toMap();

      expect(map['id'], 1);
      expect(map['title'], 'Test Task');
      expect(map['description'], 'Test Description');
      expect(map['isCompleted'], 0);
      expect(map['userId'], 1);
      expect(map['createdAt'], isA<String>());
    });

    test('should create task from map correctly', () {
      final map = {
        'id': 1,
        'title': 'Test Task',
        'description': 'Test Description',
        'isCompleted': 1,
        'userId': 1,
        'createdAt': DateTime.now().toIso8601String(),
      };

      final task = Task.fromMap(map);

      expect(task.id, 1);
      expect(task.title, 'Test Task');
      expect(task.description, 'Test Description');
      expect(task.isCompleted, true);
      expect(task.userId, 1);
    });

    test('should copy task with new values', () {
      final originalTask = Task(
        id: 1,
        title: 'Original Title',
        description: 'Original Description',
        userId: 1,
      );

      final copiedTask = originalTask.copyWith(
        title: 'New Title',
        isCompleted: true,
      );

      expect(copiedTask.id, 1);
      expect(copiedTask.title, 'New Title');
      expect(copiedTask.description, 'Original Description');
      expect(copiedTask.isCompleted, true);
      expect(copiedTask.userId, 1);
    });

    test('should have correct equality comparison', () {
      final task1 = Task(id: 1, title: 'Task 1', description: 'Description 1', userId: 1);
      final task2 = Task(id: 1, title: 'Task 2', description: 'Description 2', userId: 1);
      final task3 = Task(id: 2, title: 'Task 1', description: 'Description 1', userId: 1);

      expect(task1 == task2, true);
      expect(task1 == task3, false); 
    });
  });
}
