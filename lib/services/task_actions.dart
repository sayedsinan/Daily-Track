import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';

class TaskActions {
  static Future<void> loadUserTasks(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    if (authProvider.currentUser != null) {
      await taskProvider.loadTasks(authProvider.currentUser!.id!);
    }
  }

  static Future<void> signOutAndClearTasks(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    taskProvider.clearTasks();
    await authProvider.signOut();
  }
}
