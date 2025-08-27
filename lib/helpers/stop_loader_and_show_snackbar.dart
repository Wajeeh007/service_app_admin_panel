import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:flutter/material.dart';

void stopLoaderAndShowSnackBar({String message = '', bool success = true, bool goBack = false}) {
  GlobalVariables.showLoader.value = false;
  if(goBack) Get.back();
  showSnackBar(message: message, success: success);
}

void showSnackBar({required String message, required bool success}) {

  String title = '';

  if(success) {
    title = lang_key.success.tr;
  } else {
    title = lang_key.error.tr;
  }

  Get.snackbar(
    title,
    message,
    colorText: primaryWhite,
    snackPosition: SnackPosition.TOP,
    backgroundColor: success == true ? Colors.lightGreen : errorRed,
    isDismissible: false,
    animationDuration: Duration(milliseconds: 800),
  );
}