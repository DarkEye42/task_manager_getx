import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:task_manager_getx/utils/app_color.dart';
import 'package:task_manager_getx/utils/app_routes.dart';
import 'package:task_manager_getx/utils/app_strings.dart';
import 'package:task_manager_getx/viewModels/auth_view_model.dart';
import 'package:task_manager_getx/viewModels/countdown_timer_view_model.dart';
import 'package:task_manager_getx/views/authScreens/forgetPasswordScreen/pinVerificationScreen/pin_verification_form.dart';
import 'package:task_manager_getx/views/authScreens/forgetPasswordScreen/pinVerificationScreen/resend_pin_layout.dart';
import 'package:task_manager_getx/views/widgets/app_snackbar.dart';
import 'package:task_manager_getx/views/widgets/forget_password_layout.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key});

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  late final List<TextEditingController> pinTEControllers;
  late final List<FocusNode> focusNodes;
  late final GlobalKey<FormState> _formKey;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    pinTEControllers = List.generate(6, (index) => TextEditingController());
    focusNodes = List.generate(6, (index) => FocusNode());
    _formKey = GlobalKey<FormState>();
    startCountDownTimer();
  }

  void startCountDownTimer() {
    final countdownTimerController = Get.find<CountdownTimerController>();
    countdownTimerController.resetCountdown();
    timer = Timer.periodic(const Duration(seconds: 1), (countdown) {
      if (countdown.tick > 60) {
        countdown.cancel();
        return;
      }
      countdownTimerController.updateCountdown();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return ForgetPasswordLayout(
            orientation: orientation,
            horizontalMargin: screenWidth * 0.1,
            verticalMargin: (orientation == Orientation.portrait)
                ? screenHeight * 0.25
                : screenHeight * 0.15,
            headerText: AppStrings.pinVerificationHeaderText,
            bodyText: AppStrings.pinVerificationBodyText,
            screenWidth: screenWidth,
            buttonWidget: const Text(
              AppStrings.pinVerificationButtonText,
            ),
            onButtonPressed: (value) {
              if (_formKey.currentState!.validate()) {
                initiatePinVerification();
                return;
              }
              AppSnackBar().showSnackBar(
                  title: AppStrings.emptyPinVerificationFieldTitle,
                  content: AppStrings.emptyPinVerificationFieldMessage,
                  contentType: ContentType.warning,
                  color: AppColor.snackBarWarningColor,
                  context: context
              );
            },
            child: Column(
              children: [
                PinVerificationForm(
                  formKey: _formKey,
                  textFieldWidth: (orientation == Orientation.portrait)
                      ? screenWidth * 0.11
                      : screenWidth * 0.09,
                  pinTEControllers: pinTEControllers,
                  focusNodes: focusNodes,
                ),
                const Gap(5),
                Obx(() {
                  final countdownTimerController = Get.find<CountdownTimerController>();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ResendPinLayout(
                      resendTimeLeft: countdownTimerController.resendTimeLeft.value,
                      email: Get.find<AuthViewModel>().recoveryEmail.value,
                      restartTimer: startCountDownTimer,
                    ),
                  );
                })
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> initiatePinVerification() async {
    String otp = pinTEControllers.map((controller) => controller.text.trim()).join();
    final authViewModel = Get.find<AuthViewModel>();
    bool status = await authViewModel.verifyOTP(otp);
    if (status) {
      timer.cancel();
      Get.offNamed(AppRoutes.setPasswordScreen);
      return;
    }
    AppSnackBar().showSnackBar(
        title: AppStrings.wrongPinVerificationFieldTitle,
        content: AppStrings.wrongPinVerificationFieldMessage,
        contentType: ContentType.failure,
        color: AppColor.snackBarFailureColor,
        context: context
    );
  }

  @override
  void dispose() {
    for (TextEditingController controller in pinTEControllers) {
      controller.dispose();
    }
    for (FocusNode focusNode in focusNodes) {
      focusNode.dispose();
    }
    timer.cancel();
    super.dispose();
  }
}