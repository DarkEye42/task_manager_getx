import 'package:get/get.dart';

class CountdownTimerController extends GetxController {
  var resendTimeLeft = 60.obs;

  void updateCountdown() {
    if (resendTimeLeft.value > 0) {
      resendTimeLeft.value--;
    }
  }

  void resetCountdown() {
    resendTimeLeft.value = 60;
  }
}
