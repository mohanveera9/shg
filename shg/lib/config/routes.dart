import 'package:flutter/material.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/language_selection_screen.dart';
import '../screens/onboarding/permissions_screen.dart';
import '../screens/auth/phone_input_screen.dart';
import '../screens/auth/otp_verification_screen.dart';
import '../screens/home/home_dashboard_screen.dart';
import '../screens/home/group_selection_screen.dart';
import '../screens/home/create_group_screen.dart';
import '../screens/home/join_group_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String languageSelection = '/language-selection';
  static const String permissions = '/permissions';
  static const String phoneInput = '/phone-input';
  static const String otpVerification = '/otp-verification';
  static const String groupSelection = '/group-selection';
  static const String createGroup = '/create-group';
  static const String joinGroup = '/join-group';
  static const String home = '/home';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      languageSelection: (context) => const LanguageSelectionScreen(),
      permissions: (context) => const PermissionsScreen(),
      phoneInput: (context) => const PhoneInputScreen(),
      otpVerification: (context) => const OtpVerificationScreen(),
      groupSelection: (context) => const GroupSelectionScreen(),
      createGroup: (context) => const CreateGroupScreen(),
      joinGroup: (context) => const JoinGroupScreen(),
      home: (context) => const HomeDashboardScreen(),
    };
  }
}
