import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helpers/scroll_controller_funcs.dart';
import '../../../models/customer.dart';

class CustomerListViewModel extends GetxController with GetSingleTickerProviderStateMixin {

  /// Controller(s) and Form Keys
  late TabController tabController;
  ScrollController scrollController = ScrollController();
    /// All Customers List
    TextEditingController allCustomersSearchController = TextEditingController();
    
    /// Active Customers List
    TextEditingController activeCustomersSearchController = TextEditingController();

    /// InActive Customers List
    TextEditingController inActiveCustomersSearchController = TextEditingController();
    
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
    animateSidePanelScrollController(scrollController);
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}