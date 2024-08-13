import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_getx/services/connectivity_checker.dart';
import 'package:task_manager_getx/themes/app_theme.dart';
import 'package:task_manager_getx/themes/theme_changer.dart';
import 'package:task_manager_getx/utils/app_routes.dart';
import 'package:task_manager_getx/utils/app_strings.dart';
import 'package:task_manager_getx/viewModels/auth_view_model.dart';
import 'package:task_manager_getx/viewModels/countdown_timer_view_model.dart';
import 'package:task_manager_getx/viewModels/dashboard_view_model.dart';
import 'package:task_manager_getx/viewModels/task_view_model.dart';
import 'package:task_manager_getx/viewModels/user_view_model.dart';

class TaskManagerApp extends StatelessWidget {
  final String userTheme;

  const TaskManagerApp({super.key, required this.userTheme});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<AuthViewModel>(() => AuthViewModel());
    Get.lazyPut<UserViewModel>(() => UserViewModel());
    Get.lazyPut<DashboardViewModel>(() => DashboardViewModel());
    Get.lazyPut<TaskViewModel>(() => TaskViewModel());
    Get.lazyPut<CountdownTimerController>(() => CountdownTimerController());
    Get.lazyPut<ThemeChanger>(() => ThemeChanger());
    Get.lazyPut<ConnectivityChecker>(() => ConnectivityChecker());

    final themeChanger = Get.find<ThemeChanger>();
    final connectivityController = Get.find<ConnectivityChecker>();

    if (!themeChanger.isAppLaunched) {
      loadUserTheme(userTheme, themeChanger);
    }
    themeChanger.setIsAppLaunched = true;
    connectivityController.initConnectivityChecker();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splashScreen,
      getPages: AppRoutes.routes,
      themeMode: themeChanger.themeMode,
      theme: AppTheme.getLightTheme(),
      darkTheme: AppTheme.getDarkTheme(),
    );
  }

  void loadUserTheme(String theme, ThemeChanger themeChanger) {
    switch (theme) {
      case AppStrings.darkMode:
        themeChanger.setThemeModeSilent = ThemeMode.dark;
        break;
      case AppStrings.lightMode:
        themeChanger.setThemeModeSilent = ThemeMode.light;
        break;
      case AppStrings.systemMode:
        themeChanger.setThemeModeSilent = ThemeMode.system;
        break;
    }
  }
}

void main() {
  runApp(const TaskManagerApp(userTheme: AppStrings.systemMode));
}