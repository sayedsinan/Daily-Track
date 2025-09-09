import 'package:daily_track/services/task_actions.dart';
import 'package:daily_track/utils/support.dart';
import 'package:daily_track/widgets/progress_indicatior.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import '../widgets/task_dialog.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => TaskActions.loadUserTasks(context),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFF14B8A6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_today,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Daily Track',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF14B8A6),
        elevation: 0,
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'profile') {
                    AuthActions.showUserProfile(context, authProvider);
                  } else if (value == 'signout') {
                    AuthActions.signOutUser(context);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'profile',
                    child: Row(
                      children: [
                        const Icon(Icons.person, color: Color(0xFF14B8A6)),
                        const SizedBox(width: 12),
                        Text(authProvider.currentUser?.name ?? 'Profile'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'signout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.red),
                        SizedBox(width: 12),
                        Text('Sign Out'),
                      ],
                    ),
                  ),
                ],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: const Color(0xFF14B8A6),
                    radius: 18,
                    child: Text(
                      authProvider.currentUser?.name
                              .substring(0, 1)
                              .toUpperCase() ??
                          'U',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer2<TaskProvider, AuthProvider>(
        builder: (context, taskProvider, authProvider, child) {
          if (taskProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF14B8A6)),
              ),
            );
          }

          if (taskProvider.tasks.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt, size: 64, color: Color(0xFF14B8A6)),
                  SizedBox(height: 16),
                  Text(
                    'No tasks yet!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF14B8A6),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap the + button to add your first task',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => TaskActions.loadUserTasks(context),
            child: Column(
              children: [
                TaskProgressIndicator(
                  progress: taskProvider.progress,
                  completedTasks: taskProvider.completedTasksCount,
                  totalTasks: taskProvider.totalTasks,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: taskProvider.tasks.length,
                    itemBuilder: (context, index) {
                      return TaskCard(
                        task: taskProvider.tasks[index],
                        onRefresh: () => TaskActions.loadUserTasks(context),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => TaskDialog(
                  userId: authProvider.currentUser!.id!,
                  onTaskAdded: () => TaskActions.loadUserTasks(context),
                ),
              );
            },
            backgroundColor: const Color(0xFF14B8A6),
            child: const Icon(Icons.add, color: Colors.white),
          );
        },
      ),
    );
  }
}
