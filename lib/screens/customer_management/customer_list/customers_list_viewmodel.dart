import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/helper_functions/scroll_controller_funcs.dart';

import '../../../models/customer.dart';

class CustomerListViewModel extends GetxController with GetSingleTickerProviderStateMixin {

  /// Controller(s) and Form Keys
  late TabController tabController;
    /// All Customers List
    TextEditingController allCustomersSearchController = TextEditingController();
    GlobalKey<FormState> allCustomersFormKey = GlobalKey<FormState>();
    
    /// Active Customers List
    TextEditingController activeCustomersSearchController = TextEditingController();
    GlobalKey<FormState> activeCustomersFormKey = GlobalKey<FormState>();

    /// InActive Customers List
    TextEditingController inActiveCustomersSearchController = TextEditingController();
    GlobalKey<FormState> inActiveCustomersFormKey = GlobalKey<FormState>();
    
  /// All Customers data list
  RxList<Customer> allCustomers = <Customer>[].obs;

  /// Active Customers data list
  RxList<Customer> activeCustomers = <Customer>[].obs;

  /// In-Active Customers data list
  RxList<Customer> inActiveCustomers = <Customer>[].obs;

  /// Arguments variable
  Map<String, dynamic>? args;

  @override
  void onInit() {
    tabController = TabController(length: 3, vsync: this);
    super.onInit();
  }

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