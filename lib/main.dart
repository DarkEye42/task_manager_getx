import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_getx/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? theme = preferences.getString("themeMode");
  theme ??= "system";

  runApp(
    TaskManagerApp(userTheme: theme),
  );
}
