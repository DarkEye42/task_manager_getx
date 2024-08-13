import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_getx/utils/app_assets.dart';
import 'package:task_manager_getx/utils/app_color.dart';

class ThemeChanger extends GetxController {
  final _themeMode = ThemeMode.system.obs;
  final _isAppLaunched = false.obs;

  ThemeMode get themeMode => _themeMode.value;
  bool get isAppLaunched => _isAppLaunched.value;

  set setIsAppLaunched(bool isAppLaunched) {
    _isAppLaunched.value = isAppLaunched;
  }

  set setThemeMode(ThemeMode mode) {
    _themeMode.value = mode;
  }

  set setThemeModeSilent(ThemeMode mode) {
    _themeMode.value = mode;
  }

  String getBackgroundImage(BuildContext context) {
    if (getThemeMode(context) == ThemeMode.dark) {
      return AppAssets.backgroundImageDark;
    }
    return AppAssets.backgroundImageLight;
  }

  ThemeMode getThemeMode(BuildContext context) {
    if (_themeMode.value == ThemeMode.system &&
        MediaQuery.of(context).platformBrightness == Brightness.dark) {
      return ThemeMode.dark;
    }
    if (_themeMode.value == ThemeMode.dark) {
      return ThemeMode.dark;
    }
    return ThemeMode.light;
  }

  Color getContainerColor(BuildContext context) {
    if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
      return AppColor.darkComponentsColor;
    }
    return Colors.white;
  }
}
