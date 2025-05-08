import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/models/order.dart';

class OrderManagementViewModel extends GetxController with GetSingleTickerProviderStateMixin{

  /// Controller(s) & Form keys
  late TabController tabController;
  TextEditingController searchController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Lists Data
    /// All Orders List
    RxList<Order> allOrdersList = <Order>[].obs;

  @override
  void onInit() {
    tabController = TabController(length: 7, vsync: this);
    super.onInit();
  }

}