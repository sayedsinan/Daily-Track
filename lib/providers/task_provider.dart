import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => List.unmodifiable(_tasks);
  bool get isLoading => _isLoading;

  List<Task> get completedTasks => _tasks.where((task) => task.isCompleted).toList();
  List<Task> get incompleteTasks => _tasks.where((task) => !task.isCompleted).toList();

  int get totalTasks => _tasks.length;
  int get completedTasksCount => completedTasks.length;

  double get progress {
    if (totalTasks == 0) return 0.0;
    return completedTasksCount / totalTasks;
  }

  Future<void> loadTasks(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _tasks = await _dbHelper.getTasksByUserId(userId);
    } catch (e) {
      _tasks = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addTask({
    required String title,
    required String description,
    required int userId,
  }) async {
    if (title.trim().isEmpty) return false;

    try {
      final task = Task(
        title: title.trim(),
        description: description.trim(),
        userId: userId,
      );

      final id = await _dbHelper.createTask(task);
      if (id > 0) {
        await loadTasks(userId); // Refresh tasks
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<bool> toggleTaskCompletion(int taskId, int userId) async {
    try {
      final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex != -1) {
        final task = _tasks[taskIndex];
        final updatedTask = task.copyWith(
          isCompleted: !task.isCompleted,
          completedAt: !task.isCompleted ? DateTime.now() : null,
        );

        await _dbHelper.updateTask(updatedTask);
        await loadTasks(userId); 
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<bool> deleteTask(int taskId, int userId) async {
    try {
      await _dbHelper.deleteTask(taskId);
      await loadTasks(userId); 
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateTask({
    required int taskId,
    required String newTitle,
    required String newDescription,
    required int userId,
  }) async {
    if (newTitle.trim().isEmpty) return false;

    try {
      final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex != -1) {
        final task = _tasks[taskIndex];
        final updatedTask = task.copyWith(
          title: newTitle.trim(),
          description: newDescription.trim(),
        );

        await _dbHelper.updateTask(updatedTask);
        await loadTasks(userId);
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  void clearTasks() {
    _tasks = [];
    notifyListeners();
  }
}
