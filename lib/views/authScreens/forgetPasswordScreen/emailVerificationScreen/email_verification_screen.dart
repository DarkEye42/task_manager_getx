import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:task_manager_getx/models/responseModel/failure.dart';
import 'package:task_manager_getx/utils/app_color.dart';
import 'package:task_manager_getx/utils/app_routes.dart';
import 'package:task_manager_getx/utils/app_strings.dart';
import 'package:task_manager_getx/viewModels/auth_view_model.dart';
import 'package:task_manager_getx/views/widgets/app_snackbar.dart';
import 'package:task_manager_getx/views/widgets/app_textfield.dart';
import 'package:task_manager_getx/views/widgets/forget_password_layout.dart';

class EmailVerificationScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();

  EmailVerificationScreen({super.key});

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
            headerText: AppStrings.emailVerificationHeaderText,
            bodyText: AppStrings.emailVerificationBodyText,
            screenWidth: screenWidth,
            buttonWidget: const Icon(
              Icons.arrow_circle_right_outlined,
              size: 30,
            ),
            onButtonPressed: (value) {
              if (_formKey.currentState!.validate()) {
                initiateOTPSending();
              }
            },
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  AppTextField(
                    focusNode: _emailFocusNode,
                    controller: _emailTEController,
                    hintText: AppStrings.emailTextFieldHint,
                    inputType: TextInputType.emailAddress,
                    errorText: AppStrings.emailErrorText,
                    regEx: AppStrings.emailRegEx,
                  ),
                  const Gap(20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> initiateOTPSending() async {
    final authController = Get.find<AuthViewModel>();
    bool status = await authController.sendOTP(_emailTEController.text.trim());
    if (status) {
      Get.offNamed(AppRoutes.pinVerificationScreen);
      return;
    }
    final response = authController.response;
    if (response is Failure) {
      int statusCode = response.statusCode;
      AppSnackBar().showSnackBar(
        title: AppStrings.sendOTPFailureTitle,
        content: (statusCode == 600)
            ? AppStrings.serverConnectionErrorText
            : AppStrings.sendOTPFailureMessage,
        contentType: ContentType.failure,
        color: AppColor.snackBarFailureColor,
        context: Get.context!,
      );
    }
  }
}
