import 'package:get/get.dart';
import 'package:service_app_admin_panel/models/customer.dart';
import 'package:service_app_admin_panel/utils/helper_functions/scroll_controller_funcs.dart';

import '../../../utils/constants.dart';

class SuspendedCustomersListViewModel extends GetxController {

  RxList<Customer> suspendedCustomersList = <Customer>[].obs;

  @override
  void onReady() {
    animateSidePanelScrollController(sidePanelScrollPositions.firstWhere((element) => element.keys.first == 'customerManagement').values.first);
    super.onReady();
  }

  @override
  void onClose() {
    detachSidePanelScrollController();
    super.onClose();
  }
}