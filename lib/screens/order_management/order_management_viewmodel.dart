import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/models/order.dart';

import '../../helpers/scroll_controller_funcs.dart';

class OrderManagementViewModel extends GetxController with GetSingleTickerProviderStateMixin{

  /// Controller(s) & Form keys
  late TabController tabController;
  ScrollController scrollController = ScrollController();
    /// All Orders Tab
    TextEditingController allOrderSearchController = TextEditingController();

    /// Pending Orders Tab
    TextEditingController pendingOrdersSearchController = TextEditingController();

    /// Accepted Orders Tab
    TextEditingController acceptedOrdersSearchController = TextEditingController();

    /// Ongoing Orders Tab
    TextEditingController ongoingOrdersSearchController = TextEditingController();

    /// Completed Orders Tab
    TextEditingController completedOrdersSearchController = TextEditingController();

    /// Cancelled Orders Tab
    TextEditingController cancelledOrdersSearchController = TextEditingController();

    /// Disputed Orders Tab
    TextEditingController disputedOrdersSearchController = TextEditingController();

  /// Controller(s) and Form keys End ///

  /// Lists Data
    /// All Orders List
    RxList<Order> allOrdersList = <Order>[].obs;
    RxList<Order> pendingOrdersList = <Order>[].obs;
    RxList<Order> acceptedOrdersList = <Order>[].obs;
    RxList<Order> ongoingOrdersList = <Order>[].obs;
    RxList<Order> completedOrdersList = <Order>[].obs;
    RxList<Order> cancelledOrdersList = <Order>[].obs;
    RxList<Order> disputedOrdersList = <Order>[].obs;

  @override
  void onInit() {
    tabController = TabController(length: 7, vsync: this);
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