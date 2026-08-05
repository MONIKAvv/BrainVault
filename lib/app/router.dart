import 'package:brainvault/features/folder/screens/folder_screen.dart';
import 'package:brainvault/features/setting/screens/settings_screen.dart';
import 'package:brainvault/features/voice_notes/screens/voice_notes_screen.dart';
import 'package:brainvault/features/remainder/screens/remainder_screen.dart';
import 'package:brainvault/features/search/screens/search_screen.dart';
import 'package:flutter/material.dart';
import '../features/ai_assistant/presentation/screens/ai_assistant_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/calendar/presentation/screens/calendar_screen.dart';
import '../features/notes/presentation/screens/note_editor_screen.dart';
import '../features/notes/presentation/screens/notes_list_screen.dart';
import '../features/onboarding/presentation/screens/home_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/onboarding/presentation/screens/splash_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/scanner/presentation/screens/scanner_screen.dart';
import '../features/tasks/presentation/screens/tasks_screen.dart';

/// Navigation router for BrainVault.
/// Manages named routes and transitions across the app.
class AppRouter {
  AppRouter._();

  // Route Constants
  static const String splashscreen = '/splashscreen';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String notesList = '/notes_list';
  static const String noteEditor = '/note_editor';
  static const String aiAssistant = '/ai_assistant';
  static const String tasks = '/tasks';
  static const String calendar = '/calendar';
  static const String scanner = '/scanner';
  static const String profile = '/profile';
  static const String folder = '/folder';
  static const String setting = '/setting';
  static const String voiceNote = '/voice_note';
  static const String remainder = '/remainder';
  static const String search = '/search';

  /// Named routes table
  static Map<String, WidgetBuilder> get routes => {
    splashscreen: (context) => const SplashScreen(),
    onboarding: (context) => const OnboardingScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    home: (context) => const HomeScreen(),
    notesList: (context) => const NotesListScreen(),
    noteEditor: (context) => const NoteEditorScreen(),
    aiAssistant: (context) => const AiAssistantScreen(),
    tasks: (context) => const TasksScreen(),
    calendar: (context) => const CalendarScreen(),
    scanner: (context) => const ScannerScreen(),
    profile: (context) => const ProfileScreen(),
    folder: (context) => const FoldersScreen(),
    setting: (context) => const SettingsScreen(),
    voiceNote: (context) => const VoiceNotesScreen(),
    remainder: (context) => const RemainderScreen(),
    search: (context) => const SearchScreen(),
  };

  /// Route generator fallback & dynamic routing
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashscreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case notesList:
        return MaterialPageRoute(builder: (_) => const NotesListScreen());
      case noteEditor:
        return MaterialPageRoute(builder: (_) => const NoteEditorScreen());
      case aiAssistant:
        return MaterialPageRoute(builder: (_) => const AiAssistantScreen());
      case tasks:
        return MaterialPageRoute(builder: (_) => const TasksScreen());
      case calendar:
        return MaterialPageRoute(builder: (_) => const CalendarScreen());
      case scanner:
        return MaterialPageRoute(builder: (_) => const ScannerScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case folder:
        return MaterialPageRoute(builder: (_) => const FoldersScreen());
      case setting:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case voiceNote:
        return MaterialPageRoute(builder: (_) => const VoiceNotesScreen());
      case remainder:
        return MaterialPageRoute(builder: (_) => const RemainderScreen());
      case search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }

  // --- Navigation Helpers ---

  /// Navigates to Login screen (replacing current route)
  static void navigateToLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(login);
  }

  /// Navigates to Register screen (pushing on top of back stack)
  static void navigateToRegister(BuildContext context) {
    Navigator.of(context).pushNamed(register);
  }

  /// Navigates to Home Dashboard (clearing back stack)
  static void navigateToHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(home, (route) => false);
  }
}
