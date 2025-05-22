import 'package:get/get.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:service_app_admin_panel/utils/helper_functions/show_snackbar.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;

void stopLoaderAndShowSnackBar(String message, bool isError) {
  GlobalVariables.showLoader.value = false;
  showSnackBar(message: lang_key.noInternetError.tr, isError: isError);
}