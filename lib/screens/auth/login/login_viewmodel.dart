import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/helpers/stop_loader_and_show_snackbar.dart';
import 'package:service_app_admin_panel/models/admin.dart';
import 'package:service_app_admin_panel/utils/api_base_helper.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:service_app_admin_panel/utils/routes.dart';
import 'package:service_app_admin_panel/utils/url_paths.dart';

import '../../../helpers/local_storage_functions.dart';

class LoginViewModel extends GetxController {

  /// Controller(s) & Form Key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  /// Observable variable for obscuring password
  RxBool obscurePassword = true.obs;

  /// Observable variable for checkbox
  RxBool checkBoxValue = false.obs;

  /// API call to login
  void login() {
    if(formKey.currentState!.validate()){
      GlobalVariables.showLoader.value = true;

      ApiBaseHelper.postMethod(
          url: Urls.login,
          withAuthorization: false,
          body: {
            'email': emailController.text.trim(),
            'password': passwordController.text.trim(),
          }).then((value) async {
            stopLoaderAndShowSnackBar(message: value.message!, success: value.success!);

            if(value.success!) {
              GlobalVariables.userDetails.value = Admin.fromJson(value.data);

              if(checkBoxValue.isTrue) {
                await LocalStorageFunctions.writeToStorage(key: isLoggedInKey, value: true);
                await LocalStorageFunctions.writeToStorage(key: tokenKey, value: value.data['token']);
                await LocalStorageFunctions.writeToStorage(key: adminDetailsKey, value: value.data['user']);
              }
              GlobalVariables.token = value.data['token'];
              GlobalVariables.userDetails.value = Admin.fromJson(value.data['user']);
              Get.offAllNamed(Routes.dashboard);
            }
          });
    }
  }
}