import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/helpers/show_snackbar.dart';
import 'package:service_app_admin_panel/models/customer.dart';
import 'package:service_app_admin_panel/utils/api_base_helper.dart';
import 'package:service_app_admin_panel/utils/global_variables.dart';
import 'package:service_app_admin_panel/utils/url_paths.dart';

import '../../../helpers/scroll_controller_funcs.dart';

class SuspendedCustomersListViewModel extends GetxController {

  ScrollController scrollController = ScrollController();

  RxList<Customer> suspendedCustomersList = <Customer>[].obs;

  @override
  void onReady() {
    animateSidePanelScrollController(scrollController);
    fetchSuspendedCustomers();
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
  
  void fetchSuspendedCustomers() {
    if(GlobalVariables.showLoader.isFalse) GlobalVariables.showLoader.value = true;
    
    ApiBaseHelper.getMethod(url: "${Urls.getCustomers}?suspended=1").then((value) {
      GlobalVariables.showLoader.value = false;

      if(value.success!) {
        final data = value.data as List;
        suspendedCustomersList.addAll(data.map((e) => Customer.fromJson(e)));
        suspendedCustomersList.refresh();
      } else {
        showSnackBar(message: value.message!, success: value.success!);
      }
    });
  }
}