import 'package:daily_track/models/task.dart';
import 'package:daily_track/models/user.dart';
import 'package:daily_track/providers/auth_provider.dart';
import 'package:daily_track/providers/task_provider.dart';
import 'package:daily_track/screens/home_screen.dart' ;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';


class MockAuthProvider extends AuthProvider {
  User? _currentUser;

  @override
  User? get currentUser => _currentUser;

  void setCurrentUser(User? user) {
    _currentUser = user;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    notifyListeners();
  }
}

class MockTaskProvider extends TaskProvider {
  List<Task> _mockTasks = [];
  bool _isLoading = false;

  @override
  List<Task> get tasks => _mockTasks;

  @override
  bool get isLoading => _isLoading;

  @override
  int get totalTasks => _mockTasks.length;

  @override
  int get completedTasksCount => _mockTasks.where((task) => task.isCompleted).length;

  @override
  double get progress {
    if (totalTasks == 0) return 0.0;
    return completedTasksCount / totalTasks;
  }

  void setTasks(List<Task> tasks) {
    _mockTasks = tasks;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  @override
  Future<void> loadTasks(int userId) async {
    // Mock implementation
  }

  @override
  void clearTasks() {
    _mockTasks.clear();
    notifyListeners();
  }
}

void main() {
  group('HomeScreen Widget Tests', () {
    late MockAuthProvider mockAuthProvider;
    late MockTaskProvider mockTaskProvider;

    setUp(() {
      mockAuthProvider = MockAuthProvider();
      mockTaskProvider = MockTaskProvider();
      
      mockAuthProvider.setCurrentUser(User(
        id: 1,
        email: 'test@example.com',
        password: 'hashed',
        name: 'Test User',
      ));
    });

    Widget createHomeScreen() {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
          ChangeNotifierProvider<TaskProvider>.value(value: mockTaskProvider),
        ],
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      );
    }

    testWidgets('displays app bar with title and user avatar', (WidgetTester tester) async {
      await tester.pumpWidget(createHomeScreen());

      expect(find.text('Daily Track'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('T'), findsOneWidget); // First letter of user's name
    });

    testWidgets('shows empty state when no tasks', (WidgetTester tester) async {
      await tester.pumpWidget(createHomeScreen());

      expect(find.text('No tasks yet!'), findsOneWidget);
      expect(find.text('Tap the + button to add your first task'), findsOneWidget);
      expect(find.byIcon(Icons.task_alt), findsOneWidget);
    });

    testWidgets('displays tasks when available', (WidgetTester tester) async {
      final tasks = [
        Task(id: 1, title: 'Task 1', description: 'Description 1', userId: 1),
        Task(id: 2, title: 'Task 2', description: 'Description 2', userId: 1, isCompleted: true),
      ];
      mockTaskProvider.setTasks(tasks);

      await tester.pumpWidget(createHomeScreen());

      expect(find.text('Task 1'), findsOneWidget);
      expect(find.text('Task 2'), findsOneWidget);
      expect(find.text('Daily Progress'), findsOneWidget);
    });

    testWidgets('shows loading state', (WidgetTester tester) async {
      mockTaskProvider.setLoading(true);

      await tester.pumpWidget(createHomeScreen());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays progress indicator with correct values', (WidgetTester tester) async {
      final tasks = [
        Task(id: 1, title: 'Task 1', description: 'Description 1', userId: 1),
        Task(id: 2, title: 'Task 2', description: 'Description 2', userId: 1, isCompleted: true),
        Task(id: 3, title: 'Task 3', description: 'Description 3', userId: 1, isCompleted: true),
      ];
      mockTaskProvider.setTasks(tasks);

      await tester.pumpWidget(createHomeScreen());

      expect(find.text('2/3'), findsOneWidget);
      expect(find.text('66% Complete'), findsOneWidget);
    });

    testWidgets('shows floating action button', (WidgetTester tester) async {
      await tester.pumpWidget(createHomeScreen());

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('opens task dialog when FAB is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createHomeScreen());
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.text('Add New Task'), findsOneWidget);
    });
    testWidgets('shows user profile menu when avatar is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createHomeScreen());
      await tester.tap(find.byType(CircleAvatar));
      await tester.pumpAndSettle();
      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('Sign Out'), findsOneWidget);
    });

    testWidgets('shows user profile dialog', (WidgetTester tester) async {
      await tester.pumpWidget(createHomeScreen());
      await tester.tap(find.byType(CircleAvatar));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Test User'));
      await tester.pumpAndSettle();

      expect(find.text('User Profile'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('handles sign out', (WidgetTester tester) async {
      await tester.pumpWidget(createHomeScreen());
      await tester.tap(find.byType(CircleAvatar));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sign Out'));
      await tester.pump();
    });

    testWidgets('supports pull to refresh', (WidgetTester tester) async {
      final tasks = [
        Task(id: 1, title: 'Task 1', description: 'Description 1', userId: 1),
      ];
      mockTaskProvider.setTasks(tasks);

      await tester.pumpWidget(createHomeScreen());
      final refreshIndicator = find.byType(RefreshIndicator);
      expect(refreshIndicator, findsOneWidget);
      await tester.drag(refreshIndicator, const Offset(0, 300));
      await tester.pump();
    });
  });
}
