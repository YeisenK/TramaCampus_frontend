import 'package:flutter/material.dart';
import '../../data/models/affiliate_business.dart';
import '../../data/models/marketplace_listing.dart';
import '../../data/models/student.dart';
import '../../features/marketplace/affiliate_detail_screen.dart';
import '../../features/marketplace/create_listing_screen.dart';
import '../../features/marketplace/listing_detail_screen.dart';
import '../../features/marketplace/marketplace_screen.dart';
import '../../features/marketplace/reservation_screen.dart';
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
import '../../features/profile/edit_profile_screen.dart';
import '../../features/connections/connections_screen.dart';
import '../../features/connections/match_success_screen.dart';
import '../../features/chat/chat_list_screen.dart';
import '../../features/chat/conversation_screen.dart';
import '../../features/settings/settings_main_screen.dart';
import '../../features/settings/settings_theme_screen.dart';
import '../../features/settings/account_settings_screen.dart';
import '../../features/settings/privacy_settings_screen.dart';
import '../../features/settings/notification_preferences_screen.dart';
import '../../features/settings/security_settings_screen.dart';
import '../../features/settings/blocked_users_screen.dart';
import '../../features/settings/delete_account_screen.dart';
import '../../features/notifications/notifications_screen.dart';
import '../../features/help/help_center_screen.dart';
import '../../features/help/faq_screen.dart';
import '../../features/help/contact_support_screen.dart';
import '../../features/help/report_problem_screen.dart';
import '../../features/legal/terms_conditions_screen.dart';
import '../../features/legal/privacy_policy_screen.dart';
import '../../features/legal/community_guidelines_screen.dart';
import '../../features/legal/about_screen.dart';
import '../../features/onboarding/login_screen.dart';

class AppRouter {
  AppRouter._();

  // Onboarding
  static const String splash = '/';
  static const String login = '/login';
  static const String welcome = '/welcome';
  static const String selectUni = '/onboarding/select-uni';
  static const String verifyEmail = '/onboarding/verify-email';
  static const String modalitySelect = '/onboarding/modality';
  static const String academicProfile = '/onboarding/academic';
  static const String personalGoals = '/onboarding/goals';
  static const String profileComplete = '/onboarding/complete';

  // Marketplace
  static const String marketplace = '/marketplace';
  static const String listingDetail = '/marketplace/listing';
  static const String affiliateDetail = '/marketplace/affiliate';
  static const String createListing = '/marketplace/create';
  static const String reservation = '/marketplace/reservation';

  // Core app
  static const String discover = '/discover';
  static const String profileDetail = '/profile-detail';
  static const String myProfile = '/my-profile';
  static const String editProfile = '/profile/edit';
  static const String connections = '/connections';
  static const String matchSuccess = '/match-success';
  static const String chatList = '/chats';
  static const String conversation = '/conversation';
  static const String notifications = '/notifications';

  // Settings
  static const String settingsMain = '/settings';
  static const String settingsTheme = '/settings/theme';
  static const String accountSettings = '/settings/account';
  static const String privacySettings = '/settings/privacy';
  static const String notificationPreferences = '/settings/notifications';
  static const String securitySettings = '/settings/security';
  static const String blockedUsers = '/settings/blocked';
  static const String deleteAccount = '/settings/delete-account';

  // Help
  static const String helpCenter = '/help';
  static const String faq = '/help/faq';
  static const String contactSupport = '/help/contact';
  static const String reportProblem = '/help/report';

  // Legal
  static const String termsConditions = '/legal/terms';
  static const String privacyPolicy = '/legal/privacy';
  static const String communityGuidelines = '/legal/community';
  static const String about = '/about';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Onboarding
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

      // Marketplace
      case marketplace:
        return _slide(const MarketplaceScreen());
      case listingDetail:
        final listing = settings.arguments as MarketplaceListing;
        return _slide(ListingDetailScreen(listing: listing));
      case affiliateDetail:
        final business = settings.arguments as AffiliateBusiness;
        return _slide(AffiliateDetailScreen(business: business));
      case createListing:
        return _slide(const CreateListingScreen());
      case reservation:
        final business = settings.arguments as AffiliateBusiness;
        return _slide(ReservationScreen(business: business));

      // Core app
      case discover:
        return _slide(const DiscoverScreen());
      case profileDetail:
        final student = settings.arguments as Student;
        return _slide(ProfileDetailScreen(student: student));
      case myProfile:
        return _slide(const MyProfileScreen());
      case editProfile:
        return _slide(const EditProfileScreen());
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
      case notifications:
        return _slide(const NotificationsScreen());

      // Settings
      case settingsMain:
        return _slide(const SettingsMainScreen());
      case settingsTheme:
        return _slide(const SettingsThemeScreen());
      case accountSettings:
        return _slide(const AccountSettingsScreen());
      case privacySettings:
        return _slide(const PrivacySettingsScreen());
      case notificationPreferences:
        return _slide(const NotificationPreferencesScreen());
      case securitySettings:
        return _slide(const SecuritySettingsScreen());
      case blockedUsers:
        return _slide(const BlockedUsersScreen());
      case deleteAccount:
        return _slide(const DeleteAccountScreen());

      // Help
      case helpCenter:
        return _slide(const HelpCenterScreen());
      case faq:
        return _slide(const FaqScreen());
      case contactSupport:
        return _slide(const ContactSupportScreen());
      case reportProblem:
        final student = settings.arguments as Student?;
        return _slide(ReportProblemScreen(reportedStudent: student));

      // Legal
      case termsConditions:
        return _slide(const TermsConditionsScreen());
      case privacyPolicy:
        return _slide(const PrivacyPolicyScreen());
      case communityGuidelines:
        return _slide(const CommunityGuidelinesScreen());
      case about:
        return _slide(const AboutScreen());

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
