import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/models/customer.dart';

import '../../../helpers/scroll_controller_funcs.dart';
import '../../../utils/constants.dart';

class SuspendedCustomersListViewModel extends GetxController {

  ScrollController scrollController = ScrollController();

  RxList<Customer> suspendedCustomersList = <Customer>[].obs;

  @override
  void onReady() {
    animateSidePanelScrollController(scrollController,sidePanelScrollPositions.firstWhere((element) => element.keys.first == 'customerManagement').values.first);
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}