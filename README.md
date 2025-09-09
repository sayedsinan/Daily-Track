# Daily Track - Enhanced Flutter To-Do App

A comprehensive to-do app built with Flutter featuring user authentication, local SQLite storage, and beautiful UI design.

## 🌟 Features

### 🔐 **Authentication System**
- User registration with email validation
- Secure login with password hashing (SHA-256)
- Forgot password functionality
- User profile management
- Session persistence with SharedPreferences

### 📱 **Task Management**
- Complete CRUD operations (Create, Read, Update, Delete)
- Mark tasks as complete/incomplete
- Visual progress tracking with animated progress bar
- Real-time task counter
- Pull-to-refresh functionality

### 💾 **Local Storage**
- SQLite database with sqflite package
- Efficient data persistence
- User-specific task isolation
- Optimized database queries

### 🎨 **Beautiful UI**
- Fresh & playful design with teal theme (#14B8A6)
- Clean, responsive interface
- Smooth animations and interactions
- Strikethrough styling for completed tasks
- Material Design 3 components

### 🏗️ **Robust Architecture**
- Provider state management
- Clean separation of concerns
- Comprehensive testing suite
- Well-structured codebase
- Error handling and loading states

## 🚀 Technical Stack

- **Framework**: Flutter 3.0+
- **Database**: SQLite (sqflite)
- **State Management**: Provider
- **Authentication**: Custom implementation with crypto
- **Storage**: SharedPreferences for session management
- **Testing**: Unit & Widget Tests
- **Architecture**: MVVM pattern

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1          # State management
  sqflite: ^2.3.0           # Local database
  path: ^1.8.3              # Path manipulation
  crypto: ^3.0.3            # Password hashing
  shared_preferences: ^2.2.2 # Session storage
  cupertino_icons: ^1.0.2   # Icons

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0     # Linting rules
```

## 🏃‍♂️ Getting Started

### Prerequisites
- Flutter 3.0 or higher
- Dart SDK 3.0 or higher

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd todo_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run tests**
   ```bash
   flutter test
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── models/                 # Data models
│   ├── user.dart          # User model
│   └── task.dart          # Task model
├── database/              # Database layer
│   └── database_helper.dart
├── services/              # Business logic services
│   └── auth_service.dart  # Authentication service
├── providers/             # State management
│   ├── auth_provider.dart # Authentication state
│   └── task_provider.dart # Task management state
├── screens/               # UI screens
│   ├── auth/
│   │   ├── login_screen.dart
│   │   ├── signup_screen.dart
│   │   └── forgot_password_screen.dart
│   └── home_screen.dart   # Main app screen
├── widgets/               # Reusable widgets
│   ├── task_card.dart     # Task display widget
│   ├── task_dialog.dart   # Add/Edit task dialog
│   └── progress_indicator.dart # Progress tracking widget
└── main.dart              # App entry point

test/                      # Test files
├── models/               # Model tests
├── services/             # Service tests
├── database/             # Database tests
└── widgets/              # Widget tests
```

## 🔥 Key Features Implementation

### Database Schema
```sql
-- Users table
CREATE TABLE users(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  name TEXT NOT NULL,
  createdAt TEXT NOT NULL
);

-- Tasks table  
CREATE TABLE tasks(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  description TEXT,
  isCompleted INTEGER NOT NULL DEFAULT 0,
  userId INTEGER NOT NULL,
  createdAt TEXT NOT NULL,
  completedAt TEXT,
  FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
);
```

### Security Features
- Password hashing using SHA-256
- SQL injection prevention with parameterized queries
- User session management
- Data isolation between users

### Performance Optimizations
- Lazy loading of tasks
- Efficient database queries
- Minimal rebuilds with Consumer widgets
- Singleton pattern for services

## 🧪 Testing

The app includes comprehensive testing:

- **Unit Tests**: Models, services, and business logic
- **Widget Tests**: UI component behavior
- **Integration Tests**: End-to-end user flows

Run specific test suites:
```bash
flutter test test/models/      # Model tests
flutter test test/services/    # Service tests  
flutter test test/widgets/     # Widget tests
```

## 🎨 Design System

### Color Palette
- **Primary**: Teal (#14B8A6)
- **Background**: Light Gray (#F8FAFC)
- **Surface**: White (#FFFFFF)
- **Error**: Red for validation errors
- **Success**: Green for confirmations

### Typography
- **Headers**: Bold, 20-28px
- **Body**: Regular, 14-16px  
- **Captions**: Light, 12-14px

### Spacing
- **Small**: 8px
- **Medium**: 16px
- **Large**: 24px
- **Extra Large**: 32px

## 🔮 Future Enhancements

- [ ] Task categories and tags
- [ ] Due dates and reminders
- [ ] Task priorities
- [ ] Dark mode support
- [ ] Cloud synchronization
- [ ] Collaboration features
- [ ] Analytics dashboard
- [ ] Export/Import functionality

## 🐛 Known Issues

- None currently reported

## 📄 License

This project is licensed under the MIT License.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

Built with ❤️ using Flutter & SQLite
*/