import 'package:service_app_admin_panel/utils/global_variables.dart';

void listSize({required int length, double itemSize = 40}) {
  GlobalVariables.listHeight.value = 270 + (length * itemSize);
}