import 'package:get/get.dart';
import 'package:task_manager_getx/views/dashboardScreen/dashboard_screen.dart';
import 'package:task_manager_getx/views/newTaskAddScreen/add_task_screen.dart';
import 'package:task_manager_getx/views/splashScreen/splash_screen.dart';
import 'package:task_manager_getx/views/updateProfileScreen/update_profile_screen.dart';
import 'package:task_manager_getx/views/authScreens/forgetPasswordScreen/emailVerificationScreen/email_verification_screen.dart';
import 'package:task_manager_getx/views/authScreens/forgetPasswordScreen/pinVerificationScreen/pin_verification_screen.dart';
import 'package:task_manager_getx/views/authScreens/forgetPasswordScreen/setPasswordScreen/set_password_screen.dart';
import 'package:task_manager_getx/views/authScreens/signInScreen/sign_in_screen.dart';
import 'package:task_manager_getx/views/authScreens/signUpScreen/sign_up_screen.dart';

class AppRoutes {
  static const String splashScreen = "/splashScreen";
  static const String signInScreen = "/signInScreen";
  static const String signUpScreen = "/signUpScreen";
  static const String dashboardScreen = "/dashboardScreen";
  static const String emailVerificationScreen = "/emailVerificationScreen";
  static const String pinVerificationScreen = "/pinVerificationScreen";
  static const String setPasswordScreen = "/setPasswordScreen";
  static const String addTaskScreen = "/addTaskScreen";
  static const String updateProfileScreen = "/updateProfileScreen";

  static final List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: signInScreen, page: () => SignInScreen()),
    GetPage(name: signUpScreen, page: () => const SignUpScreen()),
    GetPage(name: dashboardScreen, page: () => const DashboardScreen()),
    GetPage(name: emailVerificationScreen, page: () => EmailVerificationScreen()),
    GetPage(name: pinVerificationScreen, page: () => const PinVerificationScreen()),
    GetPage(name: setPasswordScreen, page: () => SetPasswordScreen()),
    GetPage(name: addTaskScreen, page: () => const AddTaskScreen()),
    GetPage(name: updateProfileScreen, page: () => const UpdateProfileScreen()),
  ];
}
