import 'package:get/get.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';

class ScrollControllerBinding extends Bindings {

  @override
  void dependencies() {
    if(GlobalVariables.scrollController.hasClients) {
      // print(GlobalVariables.scrollController.positions);
      GlobalVariables.scrollController.detach(GlobalVariables.scrollController.positions.first);
    }
  }
}