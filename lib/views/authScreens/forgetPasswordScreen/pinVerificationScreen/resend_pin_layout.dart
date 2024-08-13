import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_getx/utils/app_color.dart';
import 'package:task_manager_getx/viewModels/auth_view_model.dart';
import 'package:task_manager_getx/viewModels/countdown_timer_view_model.dart';

class ResendPinLayout extends StatelessWidget {
  final String email;
  final Function restartTimer;

  const ResendPinLayout({
    super.key,
    required this.email,
    required this.restartTimer, required int resendTimeLeft,
  });

  @override
  Widget build(BuildContext context) {
    final countdownTimerController = Get.find<CountdownTimerController>();
    final authViewModel = Get.find<AuthViewModel>();

    return Obx(() {
      final resendTimeLeft = countdownTimerController.resendTimeLeft.value;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            (resendTimeLeft == 60)
                ? "1:00"
                : "0:${resendTimeLeft.toString().padLeft(2, "0")}",
          ),
          InkWell(
            splashColor: Colors.transparent,
            onTap: () async {
              if (resendTimeLeft != 0) {
                return;
              }
              await authViewModel.sendOTP(email, isResending: true);
              restartTimer();
            },
            child: Text(
              "Resend",
              style: TextStyle(
                color: (resendTimeLeft == 0)
                    ? AppColor.appPrimaryColor
                    : Colors.grey,
              ),
            ),
          ),
        ],
      );
    });
  }
}