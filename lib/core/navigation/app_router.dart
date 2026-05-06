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
import '../../features/onboarding/identity_screen.dart';
import '../../features/onboarding/select_uni_screen.dart';
import '../../features/onboarding/verify_email_screen.dart';
import '../../features/onboarding/affiliation_screen.dart';
import '../../features/onboarding/modality_select_screen.dart';
import '../../features/onboarding/academic_profile_screen.dart';
import '../../features/onboarding/personal_goals_screen.dart';
import '../../features/onboarding/skills_select_screen.dart';
import '../../features/onboarding/avatar_screen.dart';
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
import '../../data/models/group.dart';
import '../../features/groups/group_detail_screen.dart';
import '../../features/groups/groups_discover_screen.dart';
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
  static const String identity = '/onboarding/identity';
  static const String selectUni = '/onboarding/select-uni';
  static const String verifyEmail = '/onboarding/verify-email';
  static const String affiliation = '/onboarding/affiliation';
  static const String academicProfile = '/onboarding/academic';
  static const String modalitySelect = '/onboarding/modality';
  static const String personalGoals = '/onboarding/goals';
  static const String skillsSelect = '/onboarding/skills';
  static const String avatarStep = '/onboarding/avatar';
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

  // Groups
  static const String groupsDiscover = '/groups';
  static const String groupDetail = '/groups/detail';

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
        return _slide(const SplashScreen(), settings);
      case welcome:
        return _slide(const WelcomeScreen(), settings);
      case login:
        return _slide(const LoginScreen(), settings);
      case identity:
        return _slide(const IdentityScreen(), settings);
      case selectUni:
        return _slide(const SelectUniScreen(), settings);
      case verifyEmail:
        return _slide(const VerifyEmailScreen(), settings);
      case affiliation:
        return _slide(const AffiliationScreen(), settings);
      case modalitySelect:
        return _slide(const ModalitySelectScreen(), settings);
      case academicProfile:
        return _slide(const AcademicProfileScreen(), settings);
      case skillsSelect:
        return _slide(const SkillsSelectScreen(), settings);
      case personalGoals:
        return _slide(const PersonalGoalsScreen(), settings);
      case avatarStep:
        return _slide(const AvatarScreen(), settings);
      case profileComplete:
        return _slide(const ProfileCompleteScreen(), settings);

      // Marketplace
      case marketplace:
        return _slide(const MarketplaceScreen(), settings);
      case listingDetail:
        final listing = settings.arguments as MarketplaceListing;
        return _slide(ListingDetailScreen(listing: listing), settings);
      case affiliateDetail:
        final business = settings.arguments as AffiliateBusiness;
        return _slide(AffiliateDetailScreen(business: business), settings);
      case createListing:
        return _slide(const CreateListingScreen(), settings);
      case reservation:
        final business = settings.arguments as AffiliateBusiness;
        return _slide(ReservationScreen(business: business), settings);

      // Core app
      case discover:
        return _slide(const DiscoverScreen(), settings);
      case profileDetail:
        final student = settings.arguments as Student;
        return _slide(ProfileDetailScreen(student: student), settings);
      case myProfile:
        return _slide(const MyProfileScreen(), settings);
      case editProfile:
        return _slide(const EditProfileScreen(), settings);
      case connections:
        return _slide(const ConnectionsScreen(), settings);
      case matchSuccess:
        final student = settings.arguments as Student;
        return _fade(MatchSuccessScreen(student: student), settings);
      case chatList:
        return _slide(const ChatListScreen(), settings);
      case conversation:
        final student = settings.arguments as Student;
        return _slide(ConversationScreen(student: student), settings);
      case notifications:
        return _slide(const NotificationsScreen(), settings);

      // Groups
      case groupsDiscover:
        return _slide(const GroupsDiscoverScreen(), settings);
      case groupDetail:
        final group = settings.arguments as Group;
        return _slide(GroupDetailScreen(group: group), settings);

      // Settings
      case settingsMain:
        return _slide(const SettingsMainScreen(), settings);
      case settingsTheme:
        return _slide(const SettingsThemeScreen(), settings);
      case accountSettings:
        return _slide(const AccountSettingsScreen(), settings);
      case privacySettings:
        return _slide(const PrivacySettingsScreen(), settings);
      case notificationPreferences:
        return _slide(const NotificationPreferencesScreen(), settings);
      case securitySettings:
        return _slide(const SecuritySettingsScreen(), settings);
      case blockedUsers:
        return _slide(const BlockedUsersScreen(), settings);
      case deleteAccount:
        return _slide(const DeleteAccountScreen(), settings);

      // Help
      case helpCenter:
        return _slide(const HelpCenterScreen(), settings);
      case faq:
        return _slide(const FaqScreen(), settings);
      case contactSupport:
        return _slide(const ContactSupportScreen(), settings);
      case reportProblem:
        final student = settings.arguments as Student?;
        return _slide(ReportProblemScreen(reportedStudent: student), settings);

      // Legal
      case termsConditions:
        return _slide(const TermsConditionsScreen(), settings);
      case privacyPolicy:
        return _slide(const PrivacyPolicyScreen(), settings);
      case communityGuidelines:
        return _slide(const CommunityGuidelinesScreen(), settings);
      case about:
        return _slide(const AboutScreen(), settings);

      default:
        return _slide(const SplashScreen(), settings);
    }
  }

  static PageRouteBuilder _slide(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (ctx, anim, anim2) => page,
      transitionsBuilder: (ctx, animation, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static PageRouteBuilder _fade(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (ctx, anim, anim2) => page,
      transitionsBuilder: (ctx, animation, anim2, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}
