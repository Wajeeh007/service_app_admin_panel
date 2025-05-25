import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/models/order.dart';

import '../../helpers/scroll_controller_funcs.dart';
import '../../utils/constants.dart';

class OrderManagementViewModel extends GetxController with GetSingleTickerProviderStateMixin{

  /// Controller(s) & Form keys
  late TabController tabController;
  ScrollController scrollController = ScrollController();
    /// All Orders Tab
    TextEditingController allOrderSearchController = TextEditingController();
    GlobalKey<FormState> allOrdersFormKey = GlobalKey<FormState>();

    /// Pending Orders Tab
    TextEditingController pendingOrdersSearchController = TextEditingController();
    GlobalKey<FormState> pendingOrdersFormKey = GlobalKey<FormState>();

    /// Accepted Orders Tab
    TextEditingController acceptedOrdersSearchController = TextEditingController();
    GlobalKey<FormState> acceptedOrdersFormKey = GlobalKey<FormState>();

    /// Ongoing Orders Tab
    TextEditingController ongoingOrdersSearchController = TextEditingController();
    GlobalKey<FormState> ongoingOrdersFormKey = GlobalKey<FormState>();

    /// Completed Orders Tab
    TextEditingController completedOrdersSearchController = TextEditingController();
    GlobalKey<FormState> completedOrdersFormKey = GlobalKey<FormState>();

    /// Cancelled Orders Tab
    TextEditingController cancelledOrdersSearchController = TextEditingController();
    GlobalKey<FormState> cancelledOrdersFormKey = GlobalKey<FormState>();

    /// Disputed Orders Tab
    TextEditingController disputedOrdersSearchController = TextEditingController();
    GlobalKey<FormState> disputedOrdersFormKey = GlobalKey<FormState>();

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
    animateSidePanelScrollController(
        scrollController,
        sidePanelScrollPositions.firstWhere((element) => element.keys.first == 'ordersManagement').values.first);
    super.onReady();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}