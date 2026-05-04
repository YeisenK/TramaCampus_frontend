import 'package:flutter/material.dart';
import '../../data/models/student.dart';
import '../../features/onboarding/splash_screen.dart';
import '../../features/onboarding/welcome_screen.dart';
import '../../features/onboarding/select_uni_screen.dart';
import '../../features/onboarding/verify_email_screen.dart';
import '../../features/onboarding/modality_select_screen.dart';
import '../../features/onboarding/academic_profile_screen.dart';
import '../../features/onboarding/personal_goals_screen.dart';
import '../../features/onboarding/profile_complete_screen.dart';
import '../../features/discover/discover_screen.dart';
import '../../features/profile/profile_detail_screen.dart';
import '../../features/profile/my_profile_screen.dart';
import '../../features/connections/connections_screen.dart';
import '../../features/connections/match_success_screen.dart';
import '../../features/chat/chat_list_screen.dart';
import '../../features/chat/conversation_screen.dart';
import '../../features/settings/settings_main_screen.dart';
import '../../features/settings/settings_theme_screen.dart';
import '../../features/notifications/notifications_screen.dart';
import '../../features/onboarding/login_screen.dart';

class AppRouter {
  AppRouter._();

  static const String splash = '/';
  static const String login = '/login';
  static const String welcome = '/welcome';
  static const String selectUni = '/onboarding/select-uni';
  static const String verifyEmail = '/onboarding/verify-email';
  static const String modalitySelect = '/onboarding/modality';
  static const String academicProfile = '/onboarding/academic';
  static const String personalGoals = '/onboarding/goals';
  static const String profileComplete = '/onboarding/complete';
  static const String discover = '/discover';
  static const String profileDetail = '/profile-detail';
  static const String myProfile = '/my-profile';
  static const String connections = '/connections';
  static const String matchSuccess = '/match-success';
  static const String chatList = '/chats';
  static const String conversation = '/conversation';
  static const String settingsMain = '/settings';
  static const String settingsTheme = '/settings/theme';
  static const String notifications = '/notifications';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _slide(const SplashScreen());
      case welcome:
        return _slide(const WelcomeScreen());
      case login:
        return _slide(const LoginScreen());
      case selectUni:
        return _slide(const SelectUniScreen());
      case verifyEmail:
        return _slide(const VerifyEmailScreen());
      case modalitySelect:
        return _slide(const ModalitySelectScreen());
      case academicProfile:
        return _slide(const AcademicProfileScreen());
      case personalGoals:
        return _slide(const PersonalGoalsScreen());
      case profileComplete:
        return _slide(const ProfileCompleteScreen());
      case discover:
        return _slide(const DiscoverScreen());
      case profileDetail:
        final student = settings.arguments as Student;
        return _slide(ProfileDetailScreen(student: student));
      case myProfile:
        return _slide(const MyProfileScreen());
      case connections:
        return _slide(const ConnectionsScreen());
      case matchSuccess:
        final student = settings.arguments as Student;
        return _fade(MatchSuccessScreen(student: student));
      case chatList:
        return _slide(const ChatListScreen());
      case conversation:
        final student = settings.arguments as Student;
        return _slide(ConversationScreen(student: student));
      case settingsMain:
        return _slide(const SettingsMainScreen());
      case settingsTheme:
        return _slide(const SettingsThemeScreen());
      case notifications:
        return _slide(const NotificationsScreen());
      default:
        return _slide(const SplashScreen());
    }
  }

  static PageRouteBuilder _slide(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (ctx, anim, anim2) => page,
      transitionsBuilder: (ctx, animation, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static PageRouteBuilder _fade(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (ctx, anim, anim2) => page,
      transitionsBuilder: (ctx, animation, anim2, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}
