import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_getx/models/loginModels/login_model.dart';
import 'package:task_manager_getx/models/responseModel/success.dart';
import 'package:task_manager_getx/services/auth_service.dart';
import 'package:task_manager_getx/viewModels/user_view_model.dart';

import 'package:task_manager_getx/models/loginModels/user_data.dart';
import 'package:task_manager_getx/utils/app_navigation.dart';

class AuthViewModel extends GetxController {
  var isPasswordObscured = true.obs;
  var isLoading = false.obs;
  var finalStatus = false.obs;
  var recoveryEmail = ''.obs;
  var otp = ''.obs;
  late var response;
  final AuthService authService = AuthService();
  late SharedPreferences preferences;
  final resetPasswordInformation = <String, String>{}.obs;

  bool get isPasswordObscure => isPasswordObscured.value;

  void setLoading(bool value) {
    isLoading.value = value;
  }

  Future<bool> registerUser({
    required String email,
    required String firstName,
    required String lastName,
    required String mobileNumber,
    required String password,
  }) async {
    finalStatus.value = false;
    setLoading(true);
    final userData = UserData(
      email: email,
      firstName: firstName,
      lastName: lastName,
      mobile: mobileNumber,
      password: password,
    );
    response = await authService.registration(userData);
    finalStatus.value = response is Success;
    setLoading(false);
    return finalStatus.value;
  }

  Future<bool> signInUser({
    required String email,
    required String password,
    required UserViewModel userViewModel,
  }) async {
    finalStatus.value = false;
    setLoading(true);
    response = await authService.signIn(email, password);
    if (response is Success) {
      final loginModel = LoginModel.fromJson(
        (response as Success).response as Map<String, dynamic>,
      );
      finalStatus.value = true;
      preferences = await SharedPreferences.getInstance();
      userViewModel.saveUserData(loginModel, preferences, password);
    } else {
      finalStatus.value = false;
    }
    setLoading(false);
    return finalStatus.value;
  }

  Future<bool> sendOTP(String email, {bool isResending = false}) async {
    finalStatus.value = false;
    if (!isResending) setLoading(true);
    response = await authService.requestOTP(email);
    if (response is Success) {
      final status = (response as Success).response as Map<String, dynamic>;
      if (status['status'] == 'success') {
        recoveryEmail.value = email;
        finalStatus.value = true;
      }
    }
    if (!isResending) setLoading(false);
    return finalStatus.value;
  }

  Future<bool> verifyOTP(String otp) async {
    finalStatus.value = false;
    setLoading(true);
    response = await authService.verifyOTP(otp, recoveryEmail.value);
    if (response is Success) {
      final status = (response as Success).response as Map<String, dynamic>;
      if (status['status'] == 'success') {
        this.otp.value = otp;
        finalStatus.value = true;
      }
    }
    setLoading(false);
    return finalStatus.value;
  }

  Future<bool> resetPassword(String newPassword) async {
    finalStatus.value = false;
    setLoading(true);
    resetPasswordInformation['email'] = recoveryEmail.value;
    resetPasswordInformation['OTP'] = otp.value;
    resetPasswordInformation['password'] = newPassword;
    response = await authService.resetPassword(resetPasswordInformation);
    if (response is Success) {
      final status = (response as Success).response as Map<String, dynamic>;
      if (status['status'] == 'success') {
        resetPasswordInformation.clear();
        finalStatus.value = true;
      }
    }
    setLoading(false);
    return finalStatus.value;
  }

  Future<bool> authenticateToken(String? token) async {
    if (token != null && !JwtDecoder.isExpired(token)) {
      return true;
    }
    return false;
  }

  Future<void> signOut() async {
    await AppNavigation().signOutUser();
  }

  // Method to toggle password obscurity
  void setPasswordObscure() {
    isPasswordObscured.value = !isPasswordObscured.value;
  }

}
