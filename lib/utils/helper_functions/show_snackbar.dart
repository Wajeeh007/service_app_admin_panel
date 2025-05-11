import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/utils/constants.dart';

void showSnackBar({required String message, required bool isError}) {

  String title = '';

  if(isError) {
    title = lang_key.error.tr;
  } else {
    title = lang_key.success.tr;
  }

  Get.snackbar(
      title,
      message,
    colorText: primaryWhite,
    snackPosition: SnackPosition.TOP,
    backgroundColor: isError ? errorRed : Colors.lightGreen,
    isDismissible: false,
    animationDuration: Duration(milliseconds: 800),
  );
}