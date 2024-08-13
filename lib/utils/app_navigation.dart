import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_getx/viewModels/auth_view_model.dart';
import 'app_routes.dart';

class AppNavigation {
  static AppNavigation? _instance;

  AppNavigation._();

  factory AppNavigation() {
    _instance ??= AppNavigation._();
    return _instance!;
  }

  void gotoSignIn() {
    Get.find<AuthViewModel>().setPasswordObscure();
    Get.back();
  }

  void gotoSignUp(FocusNode emailFocusNode, FocusNode passwordFocusNode) {
    Get.find<AuthViewModel>().setPasswordObscure();
    Get.toNamed(AppRoutes.signUpScreen)?.then((_) {
      emailFocusNode.unfocus();
      passwordFocusNode.unfocus();
    });
  }

  Future<void> signOutUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Get.offAllNamed(AppRoutes.signInScreen);
  }
}
