import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_getx/app/app.dart';
import 'package:task_manager_getx/viewModels/auth_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.lazyPut(() => AuthViewModel());
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? theme = preferences.getString("themeMode");
  theme ??= "system";

  runApp(
    TaskManagerApp(userTheme: theme),
  );
}
