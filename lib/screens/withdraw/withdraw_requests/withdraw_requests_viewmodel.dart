import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';
import '../../../utils/helper_functions/scroll_controller_funcs.dart';

class WithdrawRequestsViewModel extends GetxController with GetSingleTickerProviderStateMixin {

  /// Controller(s) & Form keys
  late TabController tabController;
    /// All Withdraws
    TextEditingController allWithdrawsSearchController = TextEditingController();
    GlobalKey<FormState> allWithdrawsFormKey = GlobalKey<FormState>();

    /// Pending Orders Tab
    TextEditingController pendingWithdrawsSearchController = TextEditingController();
    GlobalKey<FormState> pendingWithdrawsFormKey = GlobalKey<FormState>();

    /// Approved Orders Tab
    TextEditingController approvedWithdrawsSearchController = TextEditingController();
    GlobalKey<FormState> approvedWithdrawsOrdersFormKey = GlobalKey<FormState>();

    /// Settled Orders Tab
    TextEditingController settledWithdrawSearchController = TextEditingController();
    GlobalKey<FormState> settledWithdrawFormKey = GlobalKey<FormState>();

    /// Completed Orders Tab
    TextEditingController deniedWithdrawSearchController = TextEditingController();
    GlobalKey<FormState> deniedWithdrawFormKey = GlobalKey<FormState>();

  /// Controller(s) and Form keys End ///

  /// Lists Data
  RxList<dynamic> allOrdersList = <dynamic>[].obs;
  RxList<dynamic> pendingOrdersList = <dynamic>[].obs;
  RxList<dynamic> acceptedOrdersList = <dynamic>[].obs;
  RxList<dynamic> ongoingOrdersList = <dynamic>[].obs;
  RxList<dynamic> completedOrdersList = <dynamic>[].obs;
  RxList<dynamic> cancelledOrdersList = <dynamic>[].obs;
  RxList<dynamic> disputedOrdersList = <dynamic>[].obs;

  @override
  void onInit() {
    tabController = TabController(length: 5, vsync: this);
    super.onInit();
  }

  @override
  void onReady() {
    animateSidePanelScrollController(sidePanelScrollPositions.firstWhere((element) => element.keys.first == 'withdraws').values.first);
    super.onReady();
  }

  @override
  void onClose() {
    detachSidePanelScrollController();
    super.onClose();
  }
}