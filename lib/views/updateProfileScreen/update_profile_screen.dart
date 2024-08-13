import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_getx/models/loginModels/user_data.dart';
import 'package:task_manager_getx/models/responseModel/failure.dart';
import 'package:task_manager_getx/utils/app_color.dart';
import 'package:task_manager_getx/utils/app_strings.dart';
import 'package:task_manager_getx/viewModels/user_view_model.dart';
import 'package:task_manager_getx/views/updateProfileScreen/update_profile_screen_form.dart';
import 'package:task_manager_getx/views/widgets/app_bar.dart';
import 'package:task_manager_getx/views/widgets/background_widget.dart';

class UpdateProfileScreen extends StatelessWidget {
  final SharedPreferences? preferences;

  const UpdateProfileScreen({super.key, this.preferences});

  @override
  Widget build(BuildContext context) {
    final UserViewModel userViewModel = Get.find<UserViewModel>();

    final TextEditingController emailTEController = TextEditingController();
    final TextEditingController firstNameTEController = TextEditingController();
    final TextEditingController lastNameTEController = TextEditingController();
    final TextEditingController mobileNumberTEController =
        TextEditingController();
    final TextEditingController passwordTEController = TextEditingController();

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final FocusNode emailFocusNode = FocusNode();
    final FocusNode passwordFocusNode = FocusNode();
    final FocusNode firstNameFocusNode = FocusNode();
    final FocusNode lastNameFocusNode = FocusNode();
    final FocusNode mobileNumberFocusNode = FocusNode();

    void setInitials() {
      UserData userData = userViewModel.userData;
      emailTEController.text = userData.email.toString();
      firstNameTEController.text = userData.firstName.toString();
      lastNameTEController.text = userData.lastName.toString();
      mobileNumberTEController.text = userData.mobile.toString();
      passwordTEController.text = userData.password.toString();
    }

    void updateProfile(UserViewModel viewModel) async {
      bool status = await viewModel.updateUserData(
          email: emailTEController.text.trim(),
          firstName: firstNameTEController.text.trim(),
          lastName: lastNameTEController.text.trim(),
          mobile: mobileNumberTEController.text.trim(),
          password: passwordTEController.text);

      if (status) {
        Get.snackbar(
          AppStrings.updateProfileScreenTitle,
          AppStrings.updateUserProfileSuccessMessage,
          backgroundColor: AppColor.snackBarSuccessColor,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          icon: const Icon(Icons.check, color: Colors.white),
        );
        Get.back(); // Navigate back
        return;
      }

      Failure failure = viewModel.response as Failure;
      Get.snackbar(
        AppStrings.updateUserProfileFailureTitle,
        failure.message,
        backgroundColor: AppColor.snackBarFailureColor,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
      );
    }

    setInitials();

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: getApplicationAppBar(context: context, disableNavigation: true),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return BackgroundWidget(
            childWidget: SingleChildScrollView(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.updateProfileScreenTitle,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const Gap(15),
                    InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        userViewModel.getImageFromGallery();
                      },
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: screenWidth * 0.25,
                              decoration: const BoxDecoration(
                                  color: AppColor.photoPickerColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      bottomLeft: Radius.circular(5))),
                              alignment: Alignment.center,
                              child: Text(
                                AppStrings.photoPickerText,
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ),
                            const Gap(20),
                            SizedBox(
                              width: screenWidth * 0.55,
                              child: Obx(() {
                                if (userViewModel.imageName.isEmpty) {
                                  return const Text(
                                    overflow: TextOverflow.ellipsis,
                                    AppStrings.chooseImageFileText,
                                    style: TextStyle(color: Colors.black),
                                  );
                                }
                                return Text(
                                    overflow: TextOverflow.ellipsis,
                                    userViewModel.imageName);
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(20),
                    UpdateProfileScreenForm(
                      emailTEController: emailTEController,
                      firstNameTEController: firstNameTEController,
                      lastNameTEController: lastNameTEController,
                      mobileNumberTEController: mobileNumberTEController,
                      passwordTEController: passwordTEController,
                      formKey: formKey,
                      emailFocusNode: emailFocusNode,
                      passwordFocusNode: passwordFocusNode,
                      firstNameFocusNode: firstNameFocusNode,
                      lastNameFocusNode: lastNameFocusNode,
                      mobileNumberFocusNode: mobileNumberFocusNode,
                      onPressed: (e) => {
                        if (formKey.currentState!.validate() &&
                            !userViewModel.isLoading)
                          {updateProfile(userViewModel)}
                        else
                          {FocusScope.of(context).unfocus()}
                      })
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
