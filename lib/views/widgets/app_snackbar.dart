import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_getx/wrappers/widget_custom_animator.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class AppSnackBar {
  static AppSnackBar? _instance;

  AppSnackBar._();

  factory AppSnackBar() {
    return _instance ??= AppSnackBar._();
  }

  void showSnackBar({
    required String title,
    required String content,
    required ContentType contentType,
    required Color color, required BuildContext context,
  }) {
    Get.snackbar(
      title,
      content,
      backgroundColor: Colors.transparent,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 0,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      colorText: color,
      snackStyle: SnackStyle.FLOATING,
      isDismissible: true,
      dismissDirection: DismissDirection.down,
      icon: Icon(
        contentType == ContentType.success ? Icons.check : Icons.error,
        color: color,
      ),
      animationDuration: const Duration(seconds: 1),
      shouldIconPulse: false,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
      overlayBlur: 0,
      titleText: WidgetCustomAnimator(
        incomingEffect: WidgetTransitionEffects.incomingSlideInFromBottom(
            duration: const Duration(seconds: 1), scale: 0.4, opacity: 0.1),
        childWidget: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
      messageText: WidgetCustomAnimator(
        incomingEffect: WidgetTransitionEffects.incomingSlideInFromBottom(
            duration: const Duration(seconds: 1), scale: 0.4, opacity: 0.1),
        childWidget: Text(
          content,
          style: TextStyle(
            fontSize: 13,
            color: color,
          ),
        ),
      ),
    );
  }
}
