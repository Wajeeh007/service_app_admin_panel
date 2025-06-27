import 'package:service_app_admin_panel/helpers/show_snackbar.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:get/get.dart';

void stopLoaderAndShowSnackBar({String message = '', bool success = true, bool goBack = false}) {
  GlobalVariables.showLoader.value = false;
  if(goBack) Get.back();
  showSnackBar(message: message, success: success);
}