import 'dart:async';

import 'package:get/get.dart';

class CheckEmailViewModel extends GetxController {

  /// Email used to reset password
  RxString email = ''.obs;

  /// Variables for handling timer
  RxString remainingTime = ''.obs;
  Timer? timer;
  int time = 90;

  @override
  void onReady() {
    startTimer();
    super.onReady();
  }

  @override
  void onClose() {
    timer = null;
    super.onClose();
  }

  /// Start timer for resend OTP
  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (value) {
      remainingTime.value = formattedTime(timeInSecond: time);
      if(time != 0) time--;
    });
  }

  /// Format the time into mm:ss formats
  String formattedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }

  /// API call to resend the password reset email
  void resendEmail() {
    time = 90;
    startTimer();

  }
}