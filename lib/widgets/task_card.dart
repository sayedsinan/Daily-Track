import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../providers/auth_provider.dart';
import 'task_dialog.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onRefresh;

  const TaskCard({super.key, required this.task, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Consumer2<TaskProvider, AuthProvider>(
          builder: (context, taskProvider, authProvider, child) {
            return Checkbox(
              value: task.isCompleted,
              onChanged: (value) async {
                await taskProvider.toggleTaskCompletion(
                  task.id!,
                  authProvider.currentUser!.id!,
                );
                onRefresh?.call();
              },
              activeColor: const Color(0xFF14B8A6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            );
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: task.isCompleted ? Colors.grey[600] : Colors.grey[800],
          ),
        ),
        subtitle: task.description.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  task.description,
                  style: TextStyle(
                    fontSize: 14,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: task.isCompleted
                        ? Colors.grey[500]
                        : Colors.grey[600],
                  ),
                ),
              )
            : null,
        trailing: Consumer2<TaskProvider, AuthProvider>(
          builder: (context, taskProvider, authProvider, child) {
            return PopupMenuButton<String>(
              onSelected: (value) async {
                switch (value) {
                  case 'edit':
                    await showDialog(
                      context: context,
                      builder: (context) => TaskDialog(
                        task: task,
                        userId: authProvider.currentUser!.id!,
                        onTaskAdded: onRefresh,
                      ),
                    );
                    break;
                  case 'delete':
                    await taskProvider.deleteTask(
                      task.id!,
                      authProvider.currentUser!.id!,
                    );
                    onRefresh?.call();
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20, color: Color(0xFF14B8A6)),
                      SizedBox(width: 12),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: Colors.red),
                      SizedBox(width: 12),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
