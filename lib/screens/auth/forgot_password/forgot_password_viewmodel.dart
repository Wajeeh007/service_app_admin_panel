import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/utils/routes.dart';

class ForgotPasswordViewModel extends GetxController {

  /// Controller(s) and Form Key
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  void forgotPassword() {
    if(formKey.currentState!.validate()) {
      Get.toNamed(Routes.checkEmail);
    }
  }
}