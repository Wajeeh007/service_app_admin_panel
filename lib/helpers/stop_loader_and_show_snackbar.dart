import 'package:service_app_admin_panel/helpers/show_snackbar.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';

void stopLoaderAndShowSnackBar(String message, bool isError) {
  GlobalVariables.showLoader.value = false;
  showSnackBar(message: message, isError: isError);
}